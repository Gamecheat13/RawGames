#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\see1_code;
#include maps\_music;

#using_animtree( "generic_human" );

event1_main()
{
	//iprintlnbold( "Event 2 starts" );
	level.maxfriendlies = 5;

	//level thread setup_dead_bodies( "ev1_dead_bodies", "event_2_ends" );

	level thread ev1_objectives();
	level thread ev1_drone_trigers_manager();

	delete_ent_array( "ev1_truck_pass_by", "targetname" );

	level.hero1 resume_fire();
	level.hero2 resume_fire();

	initialize_spawn_function( "ev1_escaper", "script_noteworthy", ::ev1_initial_escape_germans );
	initialize_spawn_function( "ev1_escaper_2", "script_noteworthy", ::ev1_initial_escape_germans_2 );
	initialize_spawn_function( "ev1_tripping_over_guy", "script_noteworthy", ::ev1_tripping_over );
	initialize_spawn_function( "ev1_trench_right", "script_noteworthy", ::ev1_trench_think );
	initialize_spawn_function( "ev1_trench_right_blow_up_guy", "script_noteworthy", ::ev1_trench_right_blow_up_guy_think );
	initialize_spawn_function( "ev1_left_chargers", "script_noteworthy", ::ev1_trench_think );
	initialize_spawn_function( "ev1_trench_flame_guy", "script_noteworthy", ::ev1_trench_flame_guy_think );

	initialize_spawn_function( "ev1_left_chargers_cough1", "script_noteworthy", ::ev1_trench_think_cough1 );
	initialize_spawn_function( "ev1_left_chargers_cough2", "script_noteworthy", ::ev1_trench_think_cough2 );
	initialize_spawn_function( "ev1_trench_right_cough1", "script_noteworthy", ::ev1_trench_think_cough1 );
	initialize_spawn_function( "ev1_trench_right_cough2", "script_noteworthy", ::ev1_trench_think_cough2 );

	//level thread ev1_floating_body( "floating_body1", "floating_body1_loop" );
	//level thread ev1_floating_body( "floating_body2", "floating_body2_loop" );

	level.hero1 thread scripted_molotov_throw_triggered( "restore_accuracy_1", "targetname", "molotov_toss_point_2", "event_2_ends" );
	level.hero2 thread scripted_molotov_throw_triggered( "right_path_picked", "targetname", "molotov_toss_point_3", "event_2_ends" );
	level.hero2 thread scripted_molotov_throw_triggered( "molotov_path_right_2", "script_noteworthy", "molotov_toss_point_4", "event_2_ends" );

	level thread ev1_disable_left_side_triggers();
	level thread ev1_disable_right_side_triggers();

	level thread ev1_right_side_tank_battle();
	level thread ev1_truck_falling_off_bridge();

	level thread ev1_plane_bomb_m();
	level thread ev1_plane_bomb_l();
	level thread ev1_plane_bomb_r();

	level thread river_dialog();
	level thread river_halfway_dialog();

	level thread dialog_left_path_top();
	level thread dialog_trench_center();

	level thread cough_run_manager();

	level thread mg_guide();

	end_trigger = getent( "end_forest", "targetname" );
	end_trigger waittill( "trigger" );
	
	level notify( "event_2_ends" );
	level thread ev1_cleanup();

	//level thread ev2_tank_mantle();

	level thread temp_skip_to_event_2();
}


ev1_objectives()
{
	trigger = getent( "ev1_move_init_enemies", "targetname" );
	trigger waittill( "trigger" );

	objective_state( 1, "done" );
	wait_network_frame();
	//objective_delete( 1 );

	// time to choose a path
	objective_add( 2, "current", level.obj2_string );
	objective_additionalposition( 2, 0, ( 2258, -1644, -897.8 ) );
	objective_additionalposition( 2, 1, ( 3907, -923, -878.3 ) );
	wait_network_frame();

	level thread ev1_left_path_obj();
	level thread ev1_right_path_obj();

	level waittill( "event_2_ends" );

	objective_position( 2, ( 326, 5854, -245.5 ) );

	//objective_state( 1, "done" );

	// disable more spawns
	//spawn_trigger = getentarray( "ev2_initial_ai_spawn", "targetname" );
	//spawn_trigger_2 = getent( "ev2_spawn_battle_1", "targetname" );
	//fc_trigger = getent( "ev2_start_fc_2", "targetname" );
	//for( i = 0; i < spawn_trigger.size; i++ )
	//{
	//	spawn_trigger[i] trigger_off();
	//}
	//spawn_trigger_2 trigger_off();
	//fc_trigger trigger_off();

	// new objective: mantle
	//objective_add( 2, "current", level.obj1c_string, ( 263, 4945, -252 ) );
	//level waittill( "ev2_tank_mantled" );

	//objective_state( 2, "done" );
	//objective_delete( 2 );

	//for( i = 0; i < spawn_trigger.size; i++ )
	//{
	//	spawn_trigger[i] trigger_on();
	//}
	//spawn_trigger_2 trigger_on();
	//spawn_trigger_2 notify( "trigger" );
	//fc_trigger trigger_on();
	//fc_trigger notify( "trigger" );
	//objective_state( 1, "done" );
}

river_dialog()
{
	trigger = getent( "ev1_escaper_start", "script_noteworthy" );
	trigger waittill( "trigger" );
		
	level.hero1 say_dialogue( "reznov", "like_rats" );
	level.hero1 say_dialogue( "reznov", "drive_back" );

	wait( 3 );

	if( !flag( "river_halfway_reached" ) )
	{
		level.hero1 say_dialogue( "reznov", "into_river" );
	}
}

river_halfway_dialog()
{
	trigger = getent( "ev1_river_halfway", "targetname" );
	trigger waittill( "trigger" );

	flag_set( "river_halfway_reached" );
	level.hero1 say_dialogue( "reznov", "instinct" );
	level.hero1 say_dialogue( "reznov", "left_or_right" );
}


ev1_left_path_obj()
{
	level endon( "right_path_picked" );

	trigger = getent( "left_path_picked", "targetname" );
	trigger waittill( "trigger" );
	level notify( "left_path_picked" );

	level thread dialog_drive_into_forest();

	objective_delete( 2 );
	wait_network_frame();
	objective_add( 2, "current", level.obj1b_string, ( 1353, -239, -836.7 ) );

	trigger = getent( "obj_right_path_1", "targetname" );
	trigger waittill( "trigger" );
	objective_position( 2, ( 1298, 3267, -504 ) );
	wait_network_frame();
	
	level.hero1 say_dialogue( "reznov", "kill_them_all2" );
}

ev1_right_path_obj()
{
	level endon( "left_path_picked" );

	trigger = getent( "right_path_picked", "targetname" );
	trigger waittill( "trigger" );
	level notify( "right_path_picked" );

	level thread dialog_drive_into_forest();

	objective_delete( 2 );
	objective_add( 2, "current", level.obj1b_string, ( 3322, 1765, -527.6 ) );
	
	trigger = getent( "obj_right_path_1", "targetname" );
	trigger waittill( "trigger" );
	objective_position( 2, ( 1298, 3267, -504 ) );
	level.hero1 say_dialogue( "reznov", "kill_them_all2" );
}

dialog_drive_into_forest()
{
	trigger = getent( "ev1_plane_trig_l", "targetname" );
	trigger waittill( "trigger" );

	level.hero1 say_dialogue( "reznov", "drive_forest" );
	wait( 2 );
	level.hero1 say_dialogue( "reznov", "burn_country" );
	//wait( 2 );
	//level.hero1 say_dialogue( "reznov", "plane_waste" );
}

ev1_disable_left_side_triggers()
{
	players = get_players();
	if( players.size == 1 )
	{
		trigger = getent( "ev1_right_end", "targetname" );
		trigger waittill( "trigger" );
		level thread dialog_right_path_top();

		//iprintlnbold( "Sgt: Enemy machinegun down there. Take it out." );

		left_triggers = getentarray( "ev2_left_side_triggers", "script_noteworthy" );
		for( i = 0; i < left_triggers.size; i++ )
		{
			left_triggers[i] trigger_off();
		}
	}
}


dialog_right_path_top()
{
	level.hero1 say_dialogue( "reznov", "mg_below" );
	level.hero1 say_dialogue( "reznov", "throw_molotov_post" );
	wait( 1 );
	//level.hero1 say_dialogue( "reznov", "drive_back" );
	//level.hero1 say_dialogue( "reznov", "trench_grave" );
}

dialog_left_path_top()
{
	trigger = getent( "ev1_left_end", "targetname" );
	trigger waittill( "trigger" );

	level.hero1 say_dialogue( "reznov", "throw_molotov_post" );
	wait( 0.5 );
	level.hero1 say_dialogue( "reznov", "kill_them_all" );
}

dialog_trench_center()
{
	trigger = getent( "trench_vo", "targetname" );
	trigger waittill( "trigger" );

	level thread dialog_flank_mg();
	wait( 4 );
	level.hero1 say_dialogue( "reznov", "trench_grave" );
}

ev1_disable_right_side_triggers()
{
	players = get_players();
	if( players.size == 1 )
	{
		trigger = getent( "ev1_left_end", "targetname" );
		trigger waittill( "trigger" );

		right_triggers = getentarray( "ev2_right_side_triggers", "script_noteworthy" );
		for( i = 0; i < right_triggers.size; i++ )
		{
			right_triggers[i] trigger_off();
		}
	}
}

ev1_initial_escape_germans()
{
	self endon( "death" );
	self.accuracy = 0.01;
	self.goalradius = 32;
	self.pacifist = 1;
	self.ignoreall = 1;
	self.animname = "generic";

	// chance to remove weapon
	index = randomint( 100 );
	if( index < 50 )
	{
		self putGunAway();
		self set_run_anim( "panick_run_1" );
	}

	wait( 4 );
	self.pacifist = 0;
	self.ignoreall = 0;
	self.health = 1;

	wait( randomint( 3 ) );
	if( isalive( self ) )
	{
		self doDamage( self.health + 25, ( 0,180,48 ) );
	}
}

ev1_initial_escape_germans_2()
{
	self endon( "death" );
	self.accuracy = 0.01;
	self.goalradius = 32;
	self.pacifist = 1;
	self.ignoreall = 1;

	index = randomint( 100 );
	if( index < 50 )
	{
		self AllowedStances( "crouch" );
	}

	link_to_point = spawn( "script_origin", self.origin );
	self linkto( link_to_point );

	trigger = getent( "ev1_move_init_enemies", "targetname" );
	trigger waittill( "trigger" );

	self unlink();
	self AllowedStances( "crouch", "stand" );

	self.health = 1;
	self.pacifist = 0;
	self.ignoreall = 0;
	self waittill( "goal" );

	//wait( 2 );

	if( isalive( self ) )
	{
		self doDamage( self.health + 25, ( 0,180,48 ) );
	}
}

ev1_tripping_over()
{
	self.accuracy = 0.01;
	self.goalradius = 32;
	self.pacifist = 1;
	self.ignoreall = 1;
	self.animname = "generic";
	self.health = self.health * 3;

	anim_node = getnode( "ev1_tripping_over_guy_1", "script_noteworthy" );

	wait( 0.5 );
	
	if( isalive( self ) )
	{
		guys = [];
		guys[0] = self;

		level anim_reach( guys, "tripping", undefined, anim_node, undefined );
		
		if( isalive( self ) )
		{
			level anim_single( guys, "tripping", undefined, anim_node, undefined );
		}
	}

	new_node = getnode( "ev1_tripping_over_guy_2", "script_noteworthy" );
	self.health = 1;
	self.goalradius = 16;
	self setgoalnode( new_node );
	self.pacifist = 0;
	self.ignoreall = 0;
}

ev1_trench_think()
{
	self thread force_to_goal( true );
	self thread goal_react_to_player();
}

goal_react_to_player()
{
	self endon( "death" );
	self endon( "goal" );

	while( 1 )
	{
		players = get_players();
		for( i = 0; i < players.size; i++ )
		{
			if( distance( players[i].origin, self.origin ) < 200 )
			{
				self resume_fire();
				return;
			}
		}

		wait( 0.2 );
	}
}


ev1_trench_think_cough1()
{
	self thread force_to_goal( true );
	self.animname = "generic";

	wait( 1 );
	self thread set_run_anim( "cough_run" );
	self waittill( "goal" );
	self thread reset_run_anim();
}

ev1_trench_think_cough2()
{
	self thread force_to_goal( true );
	self.animname = "generic";

	wait( 2 );
	self thread set_run_anim( "cough_run" );
	self waittill( "goal" );
	self thread reset_run_anim();
}

ev1_right_side_tank_battle()
{
	level endon( "event_2_ends" );

	start_trigger = getent( "ev1_tank_battle", "targetname" );
	start_trigger waittill( "trigger" );

	// 1: spawn 4 tanks and put them on the rail
	
	start_node_1 = getvehiclenode( "ev1_tank_1_start", "targetname" );
	tank1 = spawnvehicle( "vehicle_rus_tracked_t34", 
						 "tank1", 
						 "t34", 
						 start_node_1.origin, 
						 start_node_1.angles );		
	tank1.vehicletype = "t34";
	vehicle_init( tank1 );
	tank1 maps\_vehicle::mgoff();
	tank1 attachPath( start_node_1 );
	tank1.health = 100000;

	start_node_2 = getvehiclenode( "ev1_tank_2_start", "targetname" );
	tank2 = spawnvehicle( "vehicle_rus_tracked_t34", 
						 "tank2", 
						 "t34", 
						 start_node_2.origin, 
						 start_node_2.angles );		
	tank2.vehicletype = "t34";
	vehicle_init( tank2 );	
	tank2 maps\_vehicle::mgoff();
	tank2 attachPath( start_node_2 );
	tank2.health = 100000;

	start_node_3 = getvehiclenode( "ev1_tank_3_start", "targetname" );
	tank3 = spawnvehicle( "vehicle_ger_tracked_king_tiger", 
						 "tank3", 
						 "tiger", 
						 start_node_3.origin, 
						 start_node_3.angles );		
	tank3.vehicletype = "tiger";
	vehicle_init( tank3 );
	tank3 maps\_vehicle::mgoff();
	tank3 attachPath( start_node_3 );
	tank3.health = 100000;
	
	start_node_4 = getvehiclenode( "ev1_tank_4_start", "targetname" );
	tank4 = spawnvehicle( "vehicle_ger_tracked_king_tiger", 
						 "tank4", 
						 "tiger", 
						 start_node_4.origin, 
						 start_node_4.angles );		
	tank4.vehicletype = "tiger";
	vehicle_init( tank4 );
	tank4 maps\_vehicle::mgoff();
	tank4 attachPath( start_node_4 );
	tank4.health = 100000;

	// 2: start moving tank 1 and 2 (friendly tanks)

	tank1 startpath();
	tank2 startpath();

	// 3: At the end of path, tank 1 fires first

	tank1 waittill( "reached_end_node" );

	tank1_target = getent( "ev1_tank_1_target", "targetname" );
	tank1 SetTurretTargetEnt( tank1_target );
	tank1 waittill( "turret_on_target" );
	tank1 FireWeapon();
	//exploder( 105 );
	level notify( "target_1_destroyed" );
	playfx( level._effect["smoke_column1"], tank1_target.origin );

	// 4: Then tank 2 fires a moment later

	wait( 4 );

	tank2_target = getent( "ev1_tank_2_target", "targetname" );
	tank2 SetTurretTargetEnt( tank2_target );
	tank2 waittill( "turret_on_target" );
	tank2 FireWeapon();
	//exploder( 106 );
	level notify( "target_2_destroyed" );
	playfx( level._effect["smoke_column1"], tank2_target.origin );

	// 5: Now tank 3 and 4 shows up (enemy). Fires and blows up tank 2 while at its peak

	tank3 startpath();
	tank4 startpath();

	fire_node = getvehiclenode( "ev1_tank_3_peak", "script_noteworthy" );
	tank3 setwaitnode( fire_node );
	tank3 waittill( "reached_wait_node" );	

	tank3 SetTurretTargetEnt( tank2 );
	tank3 waittill( "turret_on_target" );
	tank3 FireWeapon();
	playfx( level._effect["tank_blow_up"], tank2.origin );
	playfx( level._effect["tank_smoke_column"], tank2.origin );
	tank2 doDamage( tank2.health + 25, ( 0,180,48 ) );
	tank2 notify( "death" );

	// 6: Tank 1 responds and fires at tank 3, kills it

	wait( 2 );

	tank1 SetTurretTargetEnt( tank3 );
	tank1 waittill( "turret_on_target" );
	tank1 FireWeapon();
	playfx( level._effect["tank_blow_up"], tank3.origin );
	playfx( level._effect["tank_smoke_column"], tank3.origin );
	tank3 doDamage( tank3.health + 25, ( 0,180,48 ) );
	tank3 notify( "death" );

	// 7: Tank 4 fires back at tank 1, damages it

	wait( 3 );

	tank4 SetTurretTargetEnt( tank1 );
	tank4 waittill( "turret_on_target" );
	tank4 FireWeapon();	// should not kill this tank instantly
	playfx( level._effect["tree_brush_fire_small"], tank1.origin + ( 0, 0, 80 ) );

	// 8: Tank 1 fires again, destroying tank 4

	wait( 3 );

	tank1 SetTurretTargetEnt( tank4 );
	tank1 waittill( "turret_on_target" );
	tank1 FireWeapon();

	playfx( level._effect["tank_blow_up"], tank4.origin );
	playfx( level._effect["tank_smoke_column"], tank4.origin );
	tank4 doDamage( tank4.health + 25, ( 0,180,48 ) );
	tank4 notify( "death" );

	wait( 2 );

	level thread ev1_burning_tank_commander( tank1 );

	wait( 2 );
	playfx( level._effect["tree_brush_fire"], tank1.origin + ( 0, 0, 80 ) );

	tank1 doDamage( tank1.health + 25, ( 0,180,48 ) );
	tank1 notify( "death" );
}

ev1_burning_tank_commander( tank )
{
	origin = tank GetTagOrigin( "tag_driver" );
	angle = tank GetTagAngles( "tag_driver" );

	german = spawn_fake_guy_to_anim_2( origin, angle, "allies", "t34_man", "guy" );
	german thread animscripts\death::flame_death_fx();
	level thread anim_open_hatch( tank );
	level anim_single_solo( german, "flame_death_climb_out", undefined, german );
}	

ev1_trench_right_blow_up_guy_think()
{
	self endon( "death" );
	self.animname = "generic";

	self waittill( "goal" );

	//wait( 3 );
	// play explosion
	playfx( level._effect["dirt_blow_up"], ( 4467, -194.5, -726.2 ) );
	//self.deathanim = %ch_makinraid_blown_into_shed;

	wait( 0.1 );

	node = getnode( "ev1_trench_right_blow_up_node", "script_noteworthy" );
	node thread anim_single_solo( self, "death_explosion_far" );

	wait( 0.5 );
	self startragdoll();
	self dodamage( self.health + 100, ( 0, 0, 0 ) );
}

/////////////////////////////////////////////////////////////////////////////////////////

#using_animtree ("see1_t34");
anim_open_hatch( tank )
{
	tank.animname = "t34";
	tank UseAnimTree( #animtree );

	tank setflaggedanim( "anim", %v_seelow1_tank_hatch_open, 1, 0.1, 1 );
}

#using_animtree("generic_human");

/////////////////////////////////////////////////////////////////////////////////////////


ev1_drone_trigers_manager()
{
	left_loop_trigger = getent( "ev1_left_drones_1", "script_noteworthy" );
	right_loop_trigger = getent( "ev1_right_drones_1", "script_noteworthy" );
	left_mutex_trigger = getent( "ev1_left_drones_2", "script_noteworthy" );
	right_mutex_trigger = getent( "ev1_right_drones_2", "script_noteworthy" );

	level thread auto_turn_off_trigger( left_loop_trigger, 30 );
	level thread auto_turn_off_trigger( right_loop_trigger, 30 );

	level thread auto_mutex_triggers( left_mutex_trigger, right_mutex_trigger );
}

temp_skip_to_event_2()
{
	enemies = getAIArray( "axis" );
	for( i = 0; i < enemies.size; i++ )
	{
		if( isalive( enemies[i] ) )
		{
			if( !isdefined( enemies[i].script_noteworthy ) || enemies[i].script_noteworthy != "forest_end_guys" )
			{
				enemies[i] enemies_delayed_kill( 5 );
			}
		}
	}
}

enemies_delayed_kill( time )
{
	self endon( "death" );
	wait( randomfloat( 2 ) + randomfloat( time ) );
	self dodamage( self.health + 100, ( 0, 0, 0 ) );
}

ev1_truck_falling_off_bridge()
{
	tree = getent( "anim_tree_crash", "targetname" );
	level thread maps\see1_anim::play_tree_crash_anim( tree );

	trigger = getent( "ev2_truck_bridge_trigger", "script_noteworthy" );
	trigger waittill( "trigger" );
	//iprintlnbold( "TRUCK START" );
	


	wait( 1 );

	tank = getent( "ev1_t34_bridge", "targetname" );
	truck = getent( "ev1_opel_blown", "targetname" );
	truck.health = 99999;

	level thread ev1_truck_falling_off_bridge_tank( tank );
	level thread ev1_truck_falling_off_bridge_truck( truck );
}

ev1_truck_falling_off_bridge_tank( tank )
{
	//node = getvehiclenode( "ev1_collide_tank_target", "script_noteworthy" );
	//tank setwaitnode( node );

	//tank waittill( "reached_wait_node" );	
	//iprintlnbold( "TANK READY" );
	level waittill( "truck_explosion_ready" );
	tank setspeed( 0, 10, 10 );
	//wait( 0.3 );
	tank FireWeapon();

	wait( 2 );

	tank resumespeed( 10 );
	tank SetTurretTargetVec( ( 161, 5052, -200 ) );
	tank waittill( "turret_on_target" );
	tank FireWeapon();
	tank thread fire_loop_generic();

	tank waittill( "reached_end_node" );
	tank notify( "death" );
	tank delete();
}

#using_animtree("generic_human");
ev1_truck_falling_off_bridge_truck( truck )
{
	node = getvehiclenode( "ev1_collide_truck_target", "script_noteworthy" );

	// attach guys
	//guys = [];
	//guys[0] = spawn( "script_model", truck gettagorigin( "tag_passenger2" ) );
	//guys[1] = spawn( "script_model", truck gettagorigin( "tag_passenger3" ) );
	//guys[2] = spawn( "script_model", truck gettagorigin( "tag_passenger4" ) );
	//guys[3] = spawn( "script_model", truck gettagorigin( "tag_passenger5" ) );
	//wait( 0.1 );
	//guys[4] = spawn( "script_model", truck gettagorigin( "tag_passenger6" ) );
	//guys[5] = spawn( "script_model", truck gettagorigin( "tag_passenger7" ) );
	//guys[6] = spawn( "script_model", truck gettagorigin( "tag_passenger8" ) );
	//guys[7] = spawn( "script_model", truck gettagorigin( "tag_passenger9" ) );

	//guys[0] linkto( truck, "tag_passenger2", ( 0, 0, 0 ), ( 0, 0, 0 ) );
	//guys[1] linkto( truck, "tag_passenger3", ( 0, 0, 0 ), ( 0, 0, 0 ) );
	//guys[2] linkto( truck, "tag_passenger4", ( 0, 0, 0 ), ( 0, 0, 0 ) );
	//guys[3] linkto( truck, "tag_passenger5", ( 0, 0, 0 ), ( 0, 0, 0 ) );
	//guys[4] linkto( truck, "tag_passenger6", ( 0, 0, 0 ), ( 0, 0, 0 ) );
	//guys[5] linkto( truck, "tag_passenger7", ( 0, 0, 0 ), ( 0, 0, 0 ) );
	//guys[6] linkto( truck, "tag_passenger8", ( 0, 0, 0 ), ( 0, 0, 0 ) );
	//guys[7] linkto( truck, "tag_passenger9", ( 0, 0, 0 ), ( 0, 0, 0 ) );

	/*
	for( i = 0; i < guys.size; i++ )
	{
		guys[i] character\char_ger_wrmcht_k98::main();	
		guys[i] makeFakeAI();	
		guys[i].animname = "fake_truck_guys_" + i;	
		guys[i].weapon = "none";
		guys[i].primaryweapon = "none";
		//guys[i] see1_drone_axis_assignWeapon_german();
		guys[i] UseAnimTree( #animtree );
		guys[i] thread anim_loop_solo( guys[i], "idel_truck_ride", undefined, "stop looping");	
	}
	*/

	truck setwaitnode( node );
	truck waittill( "reached_wait_node" );	
	//iprintlnbold( "TRUCK READY" );

	level notify( "truck_explosion_ready" );

	level thread maps\see1_anim::play_truck_crash_anim( truck );

	//wait( 0.4 );
	level notify( "truck_explosion_bridge" );

	//TUEY Set Music STATE to TRUCK
	setmusicstate("TRUCK");
	
	// throw guys off
	//for( i = 0; i < guys.size; i++ )
	//{
	//	guys[i] stopanimscripted();
	//	guys[i] unlink();
	//	guys[i] thread anim_single_solo( guys[i], "explosion_thrown" );	
	//}

	//level thread delayed_ragdoll( guys[0], 1 );
	//level thread delayed_ragdoll( guys[1], 1.2 );
	//level thread delayed_ragdoll( guys[2], 1.2 );
	//level thread delayed_ragdoll( guys[3], 1.3 );
	//level thread delayed_ragdoll( guys[4], 1.4 );
	//level thread delayed_ragdoll( guys[5], 1.5 );
	//level thread delayed_ragdoll( guys[6], 1.6 );
	//level thread delayed_ragdoll( guys[7], 1.7 );

	//wait( 2 );
	//level.hero1 say_dialogue( "reznov", "i_told" );

	// clean up later
	level waittill( "move_tank_5_for_real" );

	//for( i = 0; i < guys.size; i++ )
	//{
	//	if( isdefined( guys[i] ) )
	//	{
	//		guys[i] delete();
	//	}
	//}

	level waittill( "all_tanks_destroyed" );
	if( isdefined( truck ) )
	{
		truck dodamage( truck.health + 100, (0,0,0) );
		truck notify( "death" );
		truck delete();
	}

}

delayed_ragdoll( guy, time )
{
	wait( time );

	if( isdefined( guy ) )
	{
		guy startragdoll();	
	}
}

ev1_plane_bomb_m()
{
	level endon( "event_2_ends" );

	spawn_trigger = getent( "ev1_plane_trig_m", "targetname" );
	spawn_trigger waittill( "trigger" );

	level.hero1 thread scripted_molotov_throw( "molotov_toss_point_1", "event_2_ends" );
	//level thread ev1_bombing_planes( "ev1_plane_bomb_m_start" );

	wait( 4 );

	bomb_struct_1 = getstruct( "ev1_plane_bomb_m_1", "targetname" );
	playfx( level._effect["napalm"], bomb_struct_1.origin );
	playsoundatposition("bomb1L",bomb_struct_1.origin);
}

ev1_plane_bomb_l()
{
	level endon( "event_2_ends" );

	spawn_trigger = getent( "ev1_plane_trig_l", "targetname" );
	spawn_trigger waittill( "trigger" );

	//level thread ev1_bombing_plane( "ev1_plane_bomb_l_start" );

	wait( 3 );

	bomb_struct_1 = getstruct( "ev1_plane_bomb_l_1", "targetname" );
	playfx( level._effect["napalm"], bomb_struct_1.origin );
	playsoundatposition("bomb1L",bomb_struct_1.origin);

}

ev1_plane_bomb_r()
{
	level endon( "event_2_ends" );

	spawn_trigger = getent( "ev1_plane_trig_r", "targetname" );
	spawn_trigger waittill( "trigger" );

	//level thread ev1_bombing_plane( "ev1_plane_bomb_r_start" );

	wait( 3 );

	bomb_struct_1 = getstruct( "ev1_plane_bomb_r_1", "targetname" );
	playfx( level._effect["napalm"], bomb_struct_1.origin );
	playsoundatposition("bomb1L",bomb_struct_1.origin);
}

ev1_bombing_plane( node_name )
{
	start_node = getvehiclenode( node_name, "targetname" );
	plane = spawnvehicle( "vehicle_rus_airplane_il2", 
						 "plane", 
						 "stuka", 
						 start_node.origin, 
						 start_node.angles );		

	plane attachPath( start_node );
	plane startpath();
	plane.script_numbombs = 3;
	
	plane playsound( "fly_by3" );

	plane waittill( "reached_end_node" );
	plane delete();
}

ev1_bombing_planes( node_name )
{
	start_node_array = getvehiclenodearray( node_name, "targetname" );
	for( i = 0; i < start_node_array.size; i++ )
	{
		plane = spawnvehicle( "vehicle_rus_airplane_il2", 
							 "plane", 
							 "stuka", 
							 start_node_array[i].origin, 
							 start_node_array[i].angles );		
	
		plane attachPath( start_node_array[i] );
		plane startpath();
		plane.script_numbombs = 3;
	
		plane playsound( "fly_by3" );

		plane thread delete_at_end_node();

		wait( randomfloat( 3 ) + 0.5 );
	}
}

delete_at_end_node()
{
	self waittill( "reached_end_node" );
	self delete();
}

ev2_tank_mantle()
{
	level thread kill_player_early();

	wait( 0.7 );

	t34 = getent( "ev2_t340", "targetname" );
	tiger = getent( "ev2_tiger0", "targetname" );
	
	t34.health = 99999;
	tiger.health = 99999;
	tiger setmodel( "vehicle_ger_tracked_king_tiger_d_inter" );
	tiger.tankmantle_tossbacks_remaining = 0;

	level thread dialog_mantle_intro();

	t34 FireWeapon();
	t34 thread fire_loop_generic();

	t34 waittill( "reached_end_node" );

	tiger SetTurretTargetVec( t34.origin );
	tiger waittill( "turret_on_target" );
	tiger FireWeapon();
	playfx( level._effect["tank_blow_up"], t34.origin );
	t34 notify( "death" );

	wait( 1 );
	tiger SetTurretTargetVec( ( 2031.5, 5150.5, -275.6 ) );
	tiger thread fire_loop_generic();
	tiger thread check_for_panzershreck_hit( 2 );

	level thread dialog_mantle_single_tank();

	tiger waittill( "death" );
	level notify( "ev2_tank_mantled" );

	autosave_by_name( "Tank Mantled" );
}

kill_player_early()
{
	level endon( "ev2_tank_mantled" );

	trigger = getent( "ev2_player_death_no_mantle", "targetname" );

	trigger waittill( "trigger" );
	missionfailed();
}

dialog_mantle_single_tank()
{
	level endon( "ev2_tank_mantled" );

	trigger = getent( "tank_mantle_in_position", "targetname" );

	while( 1 )
	{
		if( level.hero1 istouching( trigger ) && level.hero2 istouching( trigger ) )
		{
			break;
		}
		wait( 0.1 );
	}

//	iprintlnbold( "In Position" );

	while( 1 )
	{
		players = get_players();
		for( i = 0; i < players.size; i++ )
		{
			if( distance( players[i].origin, level.hero1.origin ) < 400 )
			{
				//iprintlnbold( "Player Close" );
			
				level.hero1 say_dialogue( "reznov", "tank_straight" );
				level.hero2 say_dialogue( "chernov", "how_armor" );
				//level.hero1 say_dialogue( "reznov", "show_chernov" );
				level.hero1 say_dialogue( "reznov", "climb_drop" );
				level thread print_text_on_screen( &"SEE1_MANTLE_TANK" );
				//level.hero1 say_dialogue( "reznov", "hurry_deal" );

				return;
			}
		}
		wait( 0.1 );
	}
}

dialog_mantle_intro()
{
	level.hero1 say_dialogue_wait( "reznov", "tank_field" );
	
	// need temp dialog
}

dialog_flank_mg()
{
	mg_t = getent( "ev1_trench_mg", "targetname" );
	//if( IsTurretFiring( mg_t ) )
	//{
	//	level.hero1 say_dialogue_wait( "reznov", "flank_mg" );
	//}

	gunner = mg_t getturretowner();

	if( isdefined( gunner ) && isalive( gunner ) )
	{
		level.hero1 say_dialogue_wait( "reznov", "flank_mg" );
	}
}

ev1_trench_flame_guy_think()
{
	self endon( "death" );
	self hold_fire();
	self.health = 99999;
	self.goalradius = 16;
	self.deathanim = %ch_peleliu1_outbunker_guy1;

	self thread animscripts\death::flame_death_fx();
	self waittill( "goal" );
	self dodamage( self.health + 100, ( 0, 0, 0 ) );
}

ev1_floating_body( anim_name, anim_loop_name )
{
	level endon( "event_2_ends" );
	start_node = getstruct( "anim_ev1_river_bodies", "targetname" );
	german = spawn_fake_guy_to_anim( "anim_ev1_river_bodies", "axis", "generic", "guy" );
	start_node anim_single_solo( german, anim_name, undefined, german );
	 

	while( 1 )
	{
		start_node anim_single_solo( german, anim_loop_name, undefined, german );
	}

}	

cough_run_manager()
{
	level endon( "event_2_ends" );

	trigger1s = getentarray( "molotov_path_right_2", "script_noteworthy" );
	trigger2s = getentarray( "forest_cough_trigger", "script_noteworthy" );

	for( i = 0; i < trigger1s.size; i++ )
	{
		level thread detect_trigger_and_cough( trigger1s[i] );
	}
	for( i = 0; i < trigger2s.size; i++ )
	{
		level thread detect_trigger_and_cough( trigger2s[i] );
	}
}

detect_trigger_and_cough( trigger )
{
	level endon( "event_2_ends" );

	trigger waittill( "trigger" );

	players = get_players();

	allies_ai = GetAiArray( "allies" );


	//for( i = 0; i < allies_ai.size; i++ )
	//{
	//	allies_ai[i] thread cough_to_goal1();
	//}


	// now find the 2 allies that are closest to the player
	closest = 0;
	second_closest = 0;
	closest_dist = 88888;
	second_closest_dist = 99999;

	for( i = 0; i < allies_ai.size; i++ )
	{
		distance_from_player = distance( players[0].origin, allies_ai[i].origin );
		if( distance_from_player < closest_dist )
		{
			// new closest found. update that, and make the original closest the 2nd closest
			second_closest = closest;
			second_closest_dist = closest_dist;
	
			closest = i;
			closest_dist = distance_from_player;
		}
		else if( distance_from_player < second_closest_dist )
		{
			// new second closest found. Update that
			second_closest = i;
			second_closest_dist = distance_from_player;
		}
	}

	if( isalive( allies_ai[closest] ) )
	{
 		allies_ai[closest] thread cough_to_goal1();
	}
	if( isalive( allies_ai[second_closest] ) )
	{
		allies_ai[second_closest] thread cough_to_goal2();
	}

}

cough_to_goal1()
{
	if( self != level.hero1 && self != level.hero2 )
	{
		self.animname = "generic";
	}
	self thread set_run_anim( "cough_run" );
	self waittill( "goal" );
	self thread reset_run_anim();
}

cough_to_goal2()
{
	if( self != level.hero1 && self != level.hero2 )
	{
		self.animname = "generic";
	}

	wait( 1.5 );

	self thread set_run_anim( "cough_run" );
	self waittill( "goal" );
	self thread reset_run_anim();
}

mg_guide()
{
	level endon( "event_2_ends" );
	level endon( "player_behind_mg" );

	mg_t = getent( "ev1_trench_mg", "targetname" );
	mg_t setturretignoregoals( true );

	temp_target = getent( "ev1_mg_fake_fire", "targetname" );
	temp_target.team = "allies";
	temp_target.script_team = "allies";
	temp_target.health = 999999;

	//level thread stop_mg_from_auto_fire2( mg_t );
	//level thread stop_mg_from_auto_fire3( mg_t );

	//player_front_trigger = getent( "ev1_mg_player_in_front", "targetname" );
	
	//mg_t SetTargetEntity( temp_target );
	//mg_t.manual_target = temp_target;
	//mg_t setturretignoregoals( true );

	// waittill the gun is mounted
	gunner = mg_t getturretowner();
	while( !isdefined( gunner ) )
	{
		wait( 0.5 );
		gunner = mg_t getturretowner();
	}
	gunner.lastStand = false;
	gunner.health = 99999;
	
	level thread detect_player_behind_mg( mg_t, gunner );
	level thread detect_player_hitting_gunner( gunner, mg_t );
	level thread check_for_gunner_leaving_mg( gunner, mg_t );
/*
	level thread stop_mg_from_auto_fire( gunner, mg_t );

	mg_t startfiring();

	while( 1 )
	{
		if( any_player_touching( player_front_trigger ) )
		{
			player = get_player_touching_trigger( player_front_trigger, temp_target );
			mg_t SetTargetEntity( player );
		}
		else
		{
			mg_t SetTargetEntity( temp_target );
			mg_t.manual_target = temp_target;
			//mg_t startfiring();
		}

		gunner = mg_t getturretowner();
		
		if( !isalive( gunner ) )
		{
			mg_t stopfiring();
			mg_t.manual_target = undefined;
			mg_t SetMode( "auto_ai" );
			mg_t restoredefaultdroppitch();
			mg_t setturretignoregoals( false );
		}

		wait( 1 );
	}
	*/
}
/*
stop_mg_from_auto_fire3( mg_t )
{
	level waittill_either( "player_behind_mg", "event_2_ends" );
	if( isdefined( mg_t ) )
	{
		mg_t stopfiring();
		mg_t.manual_target = undefined;
		mg_t SetMode( "auto_ai" );
		mg_t restoredefaultdroppitch();
		mg_t setturretignoregoals( false );
	}
}

stop_mg_from_auto_fire( gunner, mg_t )
{
	gunner waittill( "death" );

	level notify( "player_behind_mg" );

	mg_t stopfiring();
	//mg_t notify( "death" );
	mg_t.manual_target = undefined;
	mg_t SetMode( "auto_ai" );
	mg_t restoredefaultdroppitch();
	mg_t setturretignoregoals( false );
	mg_t TurretFireDisable();
	
	wait( 1 );

	mg_t TurretFireEnable();
}	

stop_mg_from_auto_fire2( mg_t )
{
	level waittill( "event_2_ends" );

	mg_t stopfiring();
	//mg_t notify( "death" );
	mg_t.manual_target = undefined;
	mg_t SetMode( "auto_ai" );
	mg_t restoredefaultdroppitch();
	mg_t setturretignoregoals( false );
	mg_t TurretFireDisable();
	
	wait( 1 );

	mg_t TurretFireEnable();
}	

get_player_touching_trigger( trigger, temp_result )
{
	players = get_players();
	for( i = 0; i < players.size; i++ )
	{
		if( players[i] istouching( trigger ) )
		{
			return players[i];
		}
	}
	return temp_result;
}
*/
detect_player_behind_mg( mg_t, gunner )
{
	level endon( "mg_gunner_shot" );
	level endon( "mg_not_used" );
	player_behind_trigger = getent( "ev1_mg_player_behind", "targetname" );
	player_behind_trigger waittill( "trigger" );

	mg_t setturretignoregoals( false );
	mg_t stopfiring();
	mg_t.manual_target = undefined;
	mg_t SetMode( "auto_ai" );
	mg_t restoredefaultdroppitch();
	gunner.health = 50;
	level notify( "player_behind_mg" );
}

detect_player_hitting_gunner( gunner, mg_t )
{
	level endon( "player_behind_mg" );
	level endon( "mg_not_used" );
	while( 1 )
	{
		gunner waittill( "damage", amount, attacker, direction_vec, point, type );
	
		if( isplayer( attacker ) )
		{
			gunner.health = 50;

			mg_t setturretignoregoals( false );
			mg_t stopfiring();
			mg_t.manual_target = undefined;
			mg_t SetMode( "auto_ai" );
			mg_t restoredefaultdroppitch();
			level notify( "mg_gunner_shot" );
			return;
		}
	}
}

check_for_gunner_leaving_mg( gunner, mg_t )
{
	level endon( "player_behind_mg" );
	level endon( "mg_gunner_shot" );
	while( 1 )
	{
		if( isturretactive( mg_t ) == false )
		{
			gunner.health = 50;
			mg_t setturretignoregoals( false );
			mg_t stopfiring();
			mg_t.manual_target = undefined;
			mg_t SetMode( "auto_ai" );
			mg_t restoredefaultdroppitch();
			level notify( "mg_not_used" );
			return;
		}
		wait( 0.1 );
	}
}

ev1_cleanup()
{
	delete_ent_array( "event_1_ends", "targetname" );
	delete_ent_array( "ev1_spawners_1", "targetname" );
	delete_ent_array( "obj_left_path_1", "targetname" );
	delete_ent_array( "ev1_left_end", "targetname" );
	delete_ent_array( "obj_right_path_1", "targetname" );
	delete_ent_array( "ev1_right_end", "targetname" );
	delete_ent_array( "ev1_truck_pass_by", "targetname" );

	delete_ent_array( "ev1_escaper_2", "script_noteworthy" );
	delete_ent_array( "ev2_left_side_triggers", "script_noteworthy" );
	delete_ent_array( "ev2_right_side_triggers", "script_noteworthy" );
	delete_ent_array( "ev1_left_drones_1", "script_noteworthy" );
	delete_ent_array( "ev1_left_drones_2", "script_noteworthy" );
	delete_ent_array( "ev1_right_drones_1", "script_noteworthy" );
	delete_ent_array( "ev1_right_drones_2", "script_noteworthy" );
	delete_ent_array( "ev1_spawners_cleanup", "script_noteworthy" );
}