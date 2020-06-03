#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\see1_code;
#include maps\see1_anim;
#include maps\_music;

#using_animtree( "generic_human" );

event3_main()
{
	// SETUP

	// standard run to cover ai
	initialize_spawn_function( "ev3_camp", "script_noteworthy", ::ev3_camp_spawn_goal );

	// enemies that are less likely to be targeted by friendlies, forcing the player to make the kill
	initialize_spawn_function( "ev3_mg42", "script_noteworthy", ::ev3_mg42_spawn_goal );

	// friendly respawners
	initialize_spawn_function( "respawners", "script_noteworthy", ::friendly_respawners_init );

	initialize_spawn_function( "ev3_defender", "script_noteworthy", ::ev3_camp_spawn_goal );
	initialize_spawn_function( "ev3_runner", "script_noteworthy", ::ev3_runner_spawn_goal );

	initialize_spawn_function( "ev3_runners_death", "script_noteworthy", ::ending_dying_near_goal_node );
	initialize_spawn_function( "ending_more_russians", "script_noteworthy", ::ending_rejoice );

	createthreatbiasgroup("ev3_mg42");  // mg42s in ev3 camp
	createthreatbiasgroup("ev3_camp");  // other enemies in ev3 camp
	createthreatbiasgroup("halftrack_gunner"); // friendlies don't shoot these guys at all

	// make the squad ignore the mgs as long as possible
	setthreatbias( "ev3_camp", "squad", 1000 );
	setthreatbias( "ev3_mg42", "squad", -1000 );
	setthreatbias( "halftrack_gunner", "squad", -1000 );

	// make everything in event 3 attack players more vigorously
	setthreatbias( "players", "ev3_mg42", 1000 );
	setthreatbias( "squad", "ev3_mg42", 100 );

	level.hero2 thread scripted_molotov_throw_triggered( "ev3_opel_spawn", "targetname", "molotov_toss_point_7", "end_truck1_spawns" );
	level.hero2 thread scripted_molotov_throw_triggered( "ev3_halftracks_move", "targetname", "molotov_toss_point_10", "end_truck1_spawns" );
	level.hero1 thread scripted_molotov_throw_triggered( "ev3_molotov_camp_1", "script_noteworthy", "molotov_toss_point_9", "end_truck1_spawns" );

	level thread ev3_objectives();

	level thread dialog_reach_compound();

	drone_triggers = getentarray( "drone_axis", "targetname" );
	for( i = 0; i < drone_triggers.size; i++ )
	{
		drone_triggers[i] delete();
	}

	//------------------------------------------------

	level thread ev3_tower_event( "tower01", true );	
	level thread ev3_tower_event( "tower02", true );	

	level thread ev3_tower_event( "tower1" );		// tower on the far right side. No tank
	level thread ev3_tower_event( "tower2" );		// Tower behind mg nest in area 1
	level thread ev3_tower_event( "tower3" );		// Tower to left of entering area 2
	level thread ev3_tower_event( "tower4" );		// Tower near the command tent
	level thread ev3_tower_event( "tower5" );		// Tower across the road from command tent

	initialize_spawn_function( "ev3_tower_guys1", "script_noteworthy", ::die_when_tower_blows1 );
	initialize_spawn_function( "ev3_tower_guys2", "script_noteworthy", ::die_when_tower_blows2 );
	initialize_spawn_function( "ev3_tower_guys3", "script_noteworthy", ::die_when_tower_blows3 );

	initialize_spawn_function( "ev3_tower_guys1", "script_noteworthy", ::ev3_mg42_spawn_goal );
	initialize_spawn_function( "ev3_tower_guys2", "script_noteworthy", ::ev3_mg42_spawn_goal );
	initialize_spawn_function( "ev3_tower_guys3", "script_noteworthy", ::ev3_mg42_spawn_goal );

	initialize_spawn_function( "ev3_tower_guys2", "script_noteworthy", ::ev3_mg42_only_player_kill2 );
	initialize_spawn_function( "ev3_tower_guys3", "script_noteworthy", ::ev3_mg42_only_player_kill3 );

	level thread dialog_tower_2_cleared();
	level thread dialog_tower_4_cleared();
	level thread dialog_last_charge();

	//level thread tower_4_destroy_mg();
	//level thread tower_5_destroy_mg();

	// Area 1: Motor pool
	level thread ev3_initial_planes();
	level thread ev3_opel_move();

	level thread ev3_opel2_event();

	// Area 2: Camp
	level thread ev3_halftracks_move();

	level thread ending_tank_1_think();

	// Area 3: Retreat
	level thread camp_center();
	level thread retreat_trucks();
	level thread retreat_planes();
	level thread retreat_tanks();
	level thread retreat_runners();
}

die_when_tower_blows1()
{
	self endon( "death" );
	level waittill( "tower2_blows_up" );
	//self dodamage( self.health + 100, ( 0, 0, 0 ) );
	level thread ev3_throw_guy_out_tower( self, "left" );
}

die_when_tower_blows2()
{
	self endon( "death" );
	level waittill( "tower4_blows_up" );
	//self dodamage( self.health + 100, ( 0, 0, 0 ) );
	level thread ev3_throw_guy_out_tower( self, "right" );
}

die_when_tower_blows3()
{
	self endon( "death" );
	level waittill( "tower5_blows_up" );
	//self dodamage( self.health + 100, ( 0, 0, 0 ) );
	level thread ev3_throw_guy_out_tower( self, "left" );
}

ev3_throw_guy_out_tower( ai_guy, dir )
{	
	ai_guy.health = 9999;
	ai_guy.animname = "generic";
	ai_guy set_random_gib();
	if( dir == "left" )
	{
		ai_guy thread anim_single_solo( ai_guy, "death_explosion_left" );
	}
	else
	{
		ai_guy thread anim_single_solo( ai_guy, "death_explosion_right" );
	}

	wait( 0.6 );
	if( dir == "left" )
	{
		ai_guy.deathanim = %death_explosion_left11;
	}
	else
	{
		ai_guy.deathanim = %death_explosion_right13;
	}
	ai_guy dodamage( ai_guy.health + 100, ( 0, 0, 0 ) );
	ai_guy startragdoll();
}


tower_4_destroy_mg()
{
	level waittill( "tower4_blows_up" );
	mg = getent( "ev3_tower_mg", "targetname" );
	mg delete();
}

tower_5_destroy_mg()
{
	level waittill( "tower5_blows_up" );
	mg = getent( "ev3_tower_mg2", "targetname" );
	mg delete();
}

ev3_mg42_only_player_kill2()
{
	self endon( "death" );
	self.health = 99999;
	while( 1 )
	{
		self waittill( "damage", amount, attacker, direction_vec, point, type );
	
		if( isplayer( attacker ) )
		{
			self.health = 1;
		}
	}
}

ev3_mg42_only_player_kill3()
{
	self endon( "death" );
	self.health = 99999;
	while( 1 )
	{
		self waittill( "damage", amount, attacker, direction_vec, point, type );
	
		if( isplayer( attacker ) )
		{
			self.health = 1;
		}
	}
}

event3_outro_test()
{
	if( level.start_point == "event3_outro" )
	{
		level thread outro( true );
	}
}


//-----------------------------------------------------------------------------------------


ev3_objectives()
{
	// End: Follow tanks up the road
	objective_state( 4, "done" );
	objective_delete( 4 );

	// Start: enter camp
	objective_add( 4, "current", level.obj8_string, ( -276, 13679, 0 ) );

	//iprintlnbold( "Sgt: Our tanks have to go around. We are going in to clear the camp." );

	//TUEY Sets music state to AT_CAMP
	setmusicstate("AT_CAMP");

	// End: enter camp (once player is far enough to trigger the opel)
	camp_entered_trigger = getent( "ev3_opel_move", "targetname" );
	camp_entered_trigger waittill( "trigger" );
	objective_state( 4, "done" );
	objective_delete( 4 );

	// Start: Clear Camp
	objective_add( 4, "current", level.obj9_string, ( -3942, 14799, -66.9 ) );

	// End: Clear Camp (Once player is far enough to trigger the halftracks)
	halftracks_move_trigger = getent( "ev3_halftracks_move", "targetname" );
	halftracks_move_trigger waittill( "trigger" );
	objective_position( 4, ( -4192, 14650, -73.7286 ) );

	level notify( "halftracks_moving" );

	level waittill( "retreat_done_done" );
	objective_state( 4, "done" );

	//level waittill( "retreat_done_done" );
	objective_add( 5, "current", level.obj11_string, ( -5254, 15555, 58 ) );

	regroup_trigger = getent( "final_regroup", "targetname" );
	regroup_trigger waittill( "trigger" );
	//wait( 1 );
	objective_state( 5, "done" );

	flag_wait( "reznov_on_tank" );
	level thread dialog_last_charge2();
	// End level
	//level waittill( "last_dialog_done" );
	wait( 12 );
	nextmission();
	//iprintlnbold( "END" );
}


ev3_camp_spawn_goal()
{
	self setthreatbiasgroup( "ev3_camp" );
	self thread force_to_goal( true );
}

ev3_runner_spawn_goal()
{
	self endon( "death" );

	goals = getnodearray( "ending_escape_node", "targetname" );
	goal = goals[ randomint( goals.size ) ];
	self setgoalpos( goal.origin );
	//self thread force_to_goal( true );
	self hold_fire();
	self.goalradius = 16;

	self thread goal_attack_to_close_player();
	self thread tracers_and_blood_damage( goal );

	while( distance( self.origin, goal.origin ) > 100 )
	{
		wait( 0.1 );
	}
	//self waittill( "goal" );
	self dodamage( self.health + 100, ( 0, 0, 0 ) );
}

tracers_and_blood_damage( goal )
{
	self endon( "death" );
	while( distance( self.origin, goal.origin ) > 800 )
	{
		wait( 0.1 );
	}
	self thread constant_tracers_to_self();
	while( distance( self.origin, goal.origin ) > 500 )
	{
		wait( 0.1 );
	}

	tags = [];
	tags[0] = "j_hip_le";
	tags[1] = "j_hip_ri";
	tags[2] = "j_head";
	tags[3] = "j_spine4";
	tags[4] = "j_elbow_le";
	tags[5] = "j_elbow_ri";
	tags[6] = "j_clavicle_le";
	tags[7] = "j_clavicle_ri";
	
	for(i = 0; i < 5; i++)
	{
		random = randomintrange(0, tags.size);

		tracer_start = ( -3391, 12983, -47.8 ) + ( randomint( 300 ) - 150, randomint( 300 ) - 150, 60 );
		BulletTracer( tracer_start, self gettagorigin( tags[random] ) );
		if( random == 2 )
		{
			playfxontag( level._effect["headshot_hit"], self, tags[random]);
			break;
		}
		else
		{
			playfxontag( level._effect["flesh_hit"], self, tags[random]);
			wait(randomfloat(0.1));
		}
	}
}

constant_tracers_to_self()
{
	self endon( "death" );

	while( 1 )
	{
		tracer_start = ( -3391, 12983, -47.8 ) + ( randomint( 300 ) - 150, randomint( 300 ) - 150, 60 );
		BulletTracer( tracer_start, self.origin + ( randomint( 20 ) - 10, randomint( 20 ) - 10, 40 ) );
		wait( randomfloat( 0.3 ) + 0.2 );
	}
}

goal_attack_to_close_player()
{
	self endon( "death" );
	self endon( "goal" );

	while( 1 )
	{
		players = get_players();
		for( i = 0; i < players.size; i++ )
		{
			if( distance( players[i].origin, self.origin ) < 80 )
			{
				self resume_fire();
				return;
			}
		}

		wait( 0.1 );
	}
}


ev3_mg42_spawn_goal()
{
	self endon( "death" );

	self setthreatbiasgroup( "ev3_mg42" );
	self thread force_to_goal( true );

	self waittill( "end_truck1_spawns" );
	self.health = 1;
	self dodamage( self.health + 100, ( 0, 0, 0 ) );
}

friendly_respawners_init()
{
	self setthreatbiasgroup( "squad" );
	self.accuracy = 0.1;
}


ending_tank_1_think()
{
	trigger = getent( "ending_spawn_tank1", "targetname" );
	trigger waittill( "trigger" );

	trigger = getent( "ev3_side_spawn_trigger", "targetname" );
	trigger notify( "trigger" );

	wait( 1 );
	tank = getent( "ending_tank_side_1", "targetname" );
	tank maps\_vehicle::mgoff();

	wait( 1 );


	/*
	spawners = getentarray( "ev3_runners_death", "targetname" );
	for( i = 0; i < spawners.size; i++ )
	{
		spawnedGuy = spawners[i] StalingradSpawn();
		spawn_failed (spawnedGuy);
		spawnedGuy thread ending_dying_near_goal_node();
	}
*/
	wait( 1 );

	tank maps\_vehicle::mgon();

	tank waittill( "reached_end_node" );
	tank SetTurretTargetVec( ( -4636.5, 15604.5, 141 ) );
	tank thread ev3_tank_shoot_and_run();
}

ending_dying_near_goal_node()
{
	self endon( "death" );
	
	self hold_fire();

	self set_random_gib(); 

	wait( 2 );
	while( distance( self.origin, self.goalpos ) > 200 )
	{
		wait( 0.1 );
	}

	self dodamage( self.health + 100, ( 0, 0, 0 ) );
}

//-----------------------------------------------------------------------------------------

// OPEL TRUCKS

ev3_opel_move()
{
	spawner = getent( "ev3_opel_spawn", "targetname" );
	spawner waittill( "trigger" );

	wait( 1 );

	opel1 = getent( "ev3_opel1", "targetname" );
	opel1.unload_group = "all";
	opel1 thread ev3_destructible_truck_death_run( "ev3_trucks_stop", "ev3_truck11_safe_point" );

	opel2 = getent( "ev3_opel2", "targetname" );
	opel2.unload_group = "all";
	opel2 thread ev3_destructible_truck_death_run( "ev3_trucks_stop", "ev3_truck12_safe_point" );

	level thread force_kill_opel2( opel2 );

	wait( 4 );
	level.hero1 thread scripted_molotov_throw( "molotov_toss_point_8", "end_truck1_spawns" );
	wait( 15 );
	
	mover = getent( "ev3_opel_move", "targetname" );
	mover notify( "trigger" );
}

force_kill_opel2( opel )
{
	opel endon( "death" );

	opel waittill( "reached_end_node" );

	wait( 2 );

	if( isdefined( opel ) )
	{
		opel.virtual_health_state = 1;
	}

	wait( 2 );

	if( isdefined( opel ) )
	{
		opel.virtual_health_state = 0;
	}
}

// This prevents the truck from blowing up before reaching the destination
// (Need to find a better way to do this)
wait_for_opel_death( opel )
{	
	opel.health = 99999;

	while( 1 )
	{
		opel waittill( "damage", amount, attacker, direction_vec, point, type );
	
		if( type == "MOD_PROJECTILE_SPLASH" || type == "MOD_PROJECTILE" || type == "MOD_EXPLOSIVE" 
		  || type == "MOD_GRENADE" || type == "MOD_GRENADE_SPLASH" )
		{
			opel dodamage( opel.health + 25, ( 0,180,48 ) );
			//RadiusDamage( opel.origin, 400, 1000, 100 );
			opel notify( "death" );
			playfx( level._effect["tank_smoke_column"], opel.origin );
	
			return;
		}
	
		opel.health = 99999;
	}
}


//-----------------------------------------------------------------------------------------

// HALFTRACKS

ev3_halftracks_move()
{
	spawn_trigger = getent( "ev3_halftrack_spawn_trigger", "targetname" );
	spawn_trigger waittill( "trigger" );

	wait( 1.5 );

	//level thread dialog_halftracks();

	level.ev3_halftrack2 = getent( "ev3_halftrack2", "targetname" );

	// Make sure the MG gunner stays on the mg, and can only be killed by player
	level.ev3_halftrack2 thread ev3_halftrack_mg_ai( "ev3_halftrack2_gunner" );

	// Make sure the halftrack can only be killed by player initiated explosions
	level.ev3_halftrack2 thread ev3_halftrack_detect_damage();
}

ev3_halftrack_detect_damage()
{
	self.health = 99999;
	while( 1 )
	{
		self waittill( "damage", amount, attacker, direction_vec, point, type );
	
		// Only the following types of damage count
		if( type == "MOD_PROJECTILE_SPLASH" || type == "MOD_PROJECTILE" || type == "MOD_GRENADE" || type == "MOD_GRENADE_SPLASH" )
		{
			self dodamage( self.health + 100, ( 0, 0, 0 ) );
			self notify( "death" );
		}
		else
		{
			self.health = 99999;
		}
	}
}

ev3_halftrack_mg_ai( gunner_noteworthy )
{
	self endon( "death" );

	//wait( 1 );

	// Go through all the attached guys, and find the gunner AI

	gunner = undefined;
	attached_guys = self.attachedguys;

	for( i = 0; i < attached_guys.size; i++ )
	{
		if( isalive( attached_guys[i] ) )
		{
			if( isdefined( attached_guys[i].script_on_vehicle_turret ) && attached_guys[i].script_on_vehicle_turret == 1 )
			{
				gunner = attached_guys[i];
				break;
			}
		}
	}

	if( !isdefined( gunner ) )
	{
		return;
	}

	// The gunner will not fight. He is scripted to play looping MG anim
	// in the vehicle anim scripts
	gunner setthreatbiasgroup( "halftrack_gunner" );
	gunner.ignoreall = 1;
	gunner.pacifist = 1;
	gunner.health = 99999;
	gunner.lastStand = false;
	self thread death_at_end();
	//gunner thread print3d_on_ent( "Gunner" );

	// Turn on the MG 
	// Note: The mg on halftrack is not operated by the AI. It is an AI itself
	// and fires regardless if an live AI is present or not
	maps\_vehicle::mgon();

	// To prevent friendlies and other enemies from killing the MG, only player
	// damage will count.
	gunner_health = 150; // 100 is normal
	attacker_player = undefined;
	while( gunner_health > 0 )
	{
		gunner waittill( "damage", amount, attacker );
		if( isplayer( attacker ) )
		{
			//iprintlnbold( "damage" );
			attacker_player = attacker;
			gunner_health -= amount;
			break;
		}
		gunner.health = 999999;
		wait( 0.05 );
	}
	arcademode_assignpoints( "arcademode_score_generic250", attacker_player );
	gunner dodamage( gunner.health + 100, ( 0, 0, 0 ) );

	// Turn off the MG when gunner is killed
	maps\_vehicle::mgoff();

	flag_set( "ev3_halftrack2_mg_killed" );

	//trigger = getent( "retreat_starts", "targetname" );
	//trigger notify( "trigger" );
}

death_at_end()
{
	self endon( "death" );
	flag_wait( "ev3_flood_spawners_end" );
	self dodamage( self.health + 100, ( 0, 0, 0 ) );
	self notify( "death" );
}

//---------------------------------------------------------------------------------------

ev3_opel2_event()
{
	move_trigger = getent( "ev3_spawn_opels_2", "targetname" );
	move_trigger waittill( "trigger" );

	level thread dialog_truck_road_shoot();

	wait( 1 );

	russians = getentarray( "ev3_truck_blowup_russians", "script_noteworthy" );
	truck1 = getent( "ev3_truck_blowup_truck1", "targetname" );
	//truck2 = getent( "ev3_truck_blowup_truck2", "targetname" );
	truck1.health = 99999;
	truck1.unload_group = "all";
	//truck2.health = 99999;

	for( i = 0; i < russians.size; i++ )
	{
		if( isalive( russians[i] ) )
		{
			russians[i] thread keep_shooting_at_truck( truck1 );
		}
	}

	//iprintlnbold( "More tucks coming up the road. Open fire on them!" );

	truck1 thread ev3_destructible_truck_death_run( "ev3_trucks_stop", "ev3_truck1_safe_point" );
	level thread ev3_track_opel_truck_death( truck1 );
	//truck2 thread ev3_destructible_truck_death_run( "ev3_trucks_stop", "ev3_truck2_safe_point" );

	//truck1 thread periodic_damage_from_russians();

	level waittill( "ev3_trucks_stop" );
	level notify( "ev3_truck_special_stop" );
	autosave_by_name( "Truck Destroyed" );
	//setthreatbias( "ev3_truck_shooters", "ev3_trucks", 1 );
	//setthreatbias( "ev3_truck_shooters", "ev3_camp", 1000 );
	
}

ev3_track_opel_truck_death( truck )
{
	truck waittill( "death" );
	level notify( "ev3_truck_destroyed" );
}

keep_shooting_at_truck( truck )
{
	self endon( "death" );

	time = 8; // seconds
	ticks = time * 10;
	for( i = 0; i < ticks; i++ )
	{
		self SetEntityTarget( truck, 1 );
		wait( 0.1 );
	}
	self ClearEntityTarget();
}	

periodic_damage_from_russians()
{
	self endon( "death" );
	wait( 3 );
	self.virtual_health_state--;
	//iprintlnbold( "damage1" );

	if( self.virtual_health_state == 2 )
	{
		playFxOnTag( level._effect["engine_smoke_light"], self, "tag_driver" );
	}
	else if( self.virtual_health_state == 1 )
	{
		playFxOnTag( level._effect["engine_smoke_heavy"], self, "tag_driver" );
	}

	wait( 2 );
	self.virtual_health_state--;
	//iprintlnbold( "damage2" );

	if( self.virtual_health_state == 2 )
	{
		playFxOnTag( level._effect["engine_smoke_light"], self, "tag_driver" );
	}
	else if( self.virtual_health_state == 1 )
	{
		playFxOnTag( level._effect["engine_smoke_heavy"], self, "tag_driver" );
	}

	wait( 1 );
	self.virtual_health_state--;
	//iprintlnbold( "damage3" );

	if( self.virtual_health_state == 2 )
	{
		playFxOnTag( level._effect["engine_smoke_light"], self, "tag_driver" );
	}
	else if( self.virtual_health_state == 1 )
	{
		playFxOnTag( level._effect["engine_smoke_heavy"], self, "tag_driver" );
	}
}


final_battle()
{
	level notify( "retreat_done_done" );
}
//---------------------------------------------------------------------------------------

outro( do_it_now )
{
	if( do_it_now == false )
	{
		level waittill( "retreat_done_done" );
	}

	wait( 1 );

	level.outroblack = NewHudElem(); 
	level.outroblack.x = 0; 
	level.outroblack.y = 0; 
	level.outroblack.horzAlign = "fullscreen"; 
	level.outroblack.vertAlign = "fullscreen"; 
	level.outroblack.foreground = false; 
	level.outroblack.sort = 50; 		
	level.outroblack SetShader( "black", 640, 480 ); 

	level.outroblack.alpha = 0;
	level.outroblack fadeOverTime(2 );
	level.outroblack.alpha = 1;

	wait( 2 );
	share_screen( get_host(), true, true );

	// teleport players
	
	link = getent( "player_temp_ending_pos", "script_noteworthy" );
	players = get_players();
	anim_node = getent( "temp_center", "targetname" );

	for( i = 0; i < players.size; i++ )
	{
		players[i] hide();
		players[i] setorigin( link.origin + (0,0,4) );
		players[i] setplayerangles( link.angles );

		//if( level.start_point != "event3_outro" )
		{
			players[i] disableWeapons();
			//level thread play_player_anim_outro( i, players[i], anim_node );
			//players[i] linkto( link );
		}
	}

	//kevin notify for emitters
	level notify("walla");

	//Tuey Set Music State "END_LEVEL"
//	setmusicstate("END_LEVEL");

	wait( 2 );
	level thread print_text_on_screen( &"SEE1_LATER" );
	wait( 5 );

	level.outroblack fadeOverTime( 3 );
	level.outroblack.alpha = 0;

	for( i = 0; i < players.size; i++ )
	{
		level thread play_player_anim_outro( i, players[i], anim_node );
	}
	level thread play_center_car_anims_side();
	level thread play_center_car_anims_middle();

	wait( 2 );
	//iprintlnbold( "OUTRO: Player get on the train." );
	wait( 33 );

	//missionsuccess( "pel1b", false );
	nextmission();
}

play_center_car_anims_side() 
{
	//anim_node = getnode( "outro_center_origin", "targetname" );
	anim_node = getent( "temp_center", "targetname" );

	guys = [];

	left_spawn_points = getstructarray( "center_car_guy_left", "targetname" );

	guys[0] = spawn_fake_guy_outro( left_spawn_points[0].origin, left_spawn_points[0].angles, "guyl1" );
	guys[1] = spawn_fake_guy_outro( left_spawn_points[1].origin, left_spawn_points[1].angles, "guyl2" );
	guys[2] = spawn_fake_guy_outro( left_spawn_points[2].origin, left_spawn_points[2].angles, "guyl3" );
	guys[3] = spawn_fake_guy_outro( left_spawn_points[3].origin, left_spawn_points[3].angles, "guyl4" );
	// This is chernov 4
	//guys[4] = spawn_fake_guy_outro( left_spawn_points[4].origin, left_spawn_points[4].angles, "guyl5" );
	guys[4] = level.hero2;
	level.hero2.animname = "guyl5";

	guys[5] = spawn_fake_guy_outro( left_spawn_points[5].origin, left_spawn_points[5].angles, "guyl6" );

	right_spawn_points = getstructarray( "center_car_guy_left", "targetname" );

	guys[6] = spawn_fake_guy_outro( right_spawn_points[0].origin, right_spawn_points[0].angles, "guyr1" );
	guys[7] = spawn_fake_guy_outro( right_spawn_points[1].origin, right_spawn_points[1].angles, "guyr2" );

	anim_node anim_single( guys, "outro" );
}

play_center_car_anims_middle() // ( R1-6 M1-6 L7-12 )
{
	anim_node = getent( "temp_center", "targetname" );

	guys = [];

	center_spawn_points = getstructarray( "center_car_guy_center", "targetname" );

	guys[0] = spawn_fake_guy_outro( center_spawn_points[0].origin, center_spawn_points[0].angles, "guyc1" );
	guys[1] = spawn_fake_guy_outro( center_spawn_points[1].origin, center_spawn_points[1].angles, "guyc2" );
	// reznov is 2
	//guys[2] = spawn_fake_guy_outro( center_spawn_points[2].origin, center_spawn_points[2].angles, "guyc3" );
	guys[2] = level.hero1;
	level.hero1.animname = "guyc3";

	guys[3] = spawn_fake_guy_outro( center_spawn_points[3].origin, center_spawn_points[3].angles, "guyc4" );

	guys[4] = spawn_fake_guy_outro( center_spawn_points[4].origin, center_spawn_points[4].angles, "guyc5" );
	guys[5] = spawn_fake_guy_outro( center_spawn_points[5].origin, center_spawn_points[5].angles, "guyc6" );

	anim_node anim_single( guys, "outro" );
}

// Spawn a drone model. It cannot be animated yet.
spawn_fake_guy_outro( startpoint, startangles, anim_name )
{
	guy = spawn( "script_model", startpoint );
	guy.angles = startangles;
	
	guy character\char_rus_r_rifle::main();
	guy maps\_drones::drone_allies_assignWeapon_russian();

	guy.team = "allies";

	guy UseAnimTree( #animtree );
	guy.animname = anim_name;
	guy makeFakeAI();
	guy.health = 100;

	return guy;
}


camp_center()
{
	trigger = getent( "camp_center_trig", "targetname" );
	trigger waittill( "trigger" );
	level notify( "both_halftracks_eliminated" );
	level thread ev3_ambient_tank_hits();

	level thread dialog_germans_retreating();
}

retreat_trucks()
{
	trigger = getent( "retreat_starts", "targetname" );
	trigger waittill( "trigger" );
	//iprintlnbold( "RRETREAT" );

	truck_spawn_1 = getent( "ending_move_truck1", "targetname" );
	truck_spawn_2 = getent( "ending_move_truck2", "targetname" );
	truck_spawn_3 = getent( "ending_move_truck3", "targetname" );

	// spawn and move first truck
	truck_spawn_1 notify( "trigger" );
	wait( 0.5 );
	truck1 = getent( "ending_truck1", "targetname" );
	truck1.health = 99999;
	level notify( "end_truck1_spawns" );

	// move second truck just a moment later
	wait( 1.5 );
	truck_spawn_2 notify( "trigger" );
	wait( 0.5 );
	truck2 = getent( "ending_truck2", "targetname" );
	truck2.health = 99999;
	level notify( "end_truck2_spawns" );

	truck2 thread stop_at_reverse_nodes();

	level thread ev3_chasing_tank_think( truck_spawn_3 );

	// When the first truck reaches a certain node, blow it up
	truck1_blow_up_node = getvehiclenode( "ending_kill_truck1", "script_noteworthy" );
	truck1 setwaitnode( truck1_blow_up_node );
	truck1 waittill( "reached_wait_node" );
	truck1 dodamage( truck1.health + 100, ( 0, 0, 0 ) );
	radiusdamage( truck1.origin, 400, 1000, 1000 );
	truck1 notify( "death" );

	// make all Germans escape
	germans = GetAiArray( "axis" );
	for( i = 0; i < germans.size; i++ )
	{
		germans[i] thread ev3_escaping_german();
	}
	level thread ending_allies_run();

	level thread ending_run_explosion();

	// stop the second truck at this time
	//wait( 0.7 );
	//truck2 setspeed( 0, 50, 50 );
	//wait( 0.5 );
	//truck2 notify( "unload" );
	//wait( 3 );
	wait( 6 );
	truck2 dodamage( truck2.health + 100, ( 0, 0, 0 ) );
	radiusdamage( truck2.origin, 400, 1000, 1000 );
	truck2 notify( "death" );

	//level thread dialog_germans_running();
}	

ending_run_explosion()
{
	wait( 4 );

	explosion_origin = ( -4799, 15378.5, 52.6 );
	
	playfx( level._effect["dirt_blow_up"], explosion_origin );

	axis_ai = GetAiArray( "axis" );

	for( i = 0; i < axis_ai.size; i++ )
	{
		if( distance( axis_ai[i].origin, explosion_origin ) < 300 )
		{
			axis_ai[i] set_random_gib();
			axis_ai[i] dodamage( axis_ai[i].health + 100, explosion_origin );
		}
	}
}

ending_allies_run()
{
	wait( 3 );

	trigger = getent( "final_friends_spawn", "targetname" );
	trigger notify( "trigger" );

	allies_ai = GetAiArray( "allies" );
	node_reznov = getnode( "reznov_final_node", "targetname" );
	node_chernov = getnode( "chernov_final_node", "targetname" );
	node_others = getnodearray( "redshirt_final_node", "targetname" );
	node_index = 0;
	for( i = 0; i < allies_ai.size; i++ )
	{
		allies_ai[i] hold_fire();
		allies_ai[i] disable_ai_color();

		if( allies_ai[i] == level.hero1 )
		{
			allies_ai[i] setgoalnode( node_reznov );
			allies_ai[i] thread rejoice_at_end();
		}
		else if( allies_ai[i] == level.hero2 )
		{
			allies_ai[i] setgoalnode( node_chernov );
			allies_ai[i] thread rejoice_at_end();
		
		}

		/*
		else 
		{
			if( isdefined( node_others[node_index] ) )
			{
				allies_ai[i] setgoalnode( node_others[node_index] );
				node_index++;
			}
		}
		allies_ai[i] thread rejoice_at_end();
		*/
	}
}

ending_rejoice()
{
	self hold_fire();
	self.goalradius = 16;
	self rejoice_at_end();
}

rejoice_at_end()
{
	if( !isdefined( self.animname ) )
	{
		self.animname = "generic";
		self waittill( "goal" );
		wait( 1 );
		level notify( "ending_in_position" );
		self anim_loop_solo( self, "rejoice" );
	}
	else if( self.animname != "reznov" && self.animname != "chernov" )
	{
		self.animname = "generic";
		self waittill( "goal" );
		wait( 1 );
		level notify( "ending_in_position" );
		self anim_loop_solo( self, "rejoice" );
	}

	else if( self.animname == "chernov" )
	{
		node_chernov = getnode( "chernov_final_node", "targetname" );
		self setgoalnode( node_chernov );
		self thread reinforce_goal_hero( node_chernov );
		self waittill( "goal" );
		wait( 1 );
		level notify( "ending_in_position" );
		self anim_loop_solo( self, "rejoice" );
	}
	else if( self.animname == "reznov" )
	{
		self disable_ai_color();
		node_reznov = getnode( "reznov_final_node", "targetname" );
		self setgoalnode( node_reznov );
		self thread reinforce_goal_hero( node_reznov );
		self waittill( "goal" );
		
		flag_wait( "ending_tank_ready" );

		regroup_trigger = getent( "final_regroup", "targetname" );
		regroup_trigger waittill( "trigger" );

		tank = getent( "ev3_ending_tanks_ride", "targetname" );
		tank anim_reach_solo( self, "cheer_tank", "tag_origin" );

		level thread play_and_loop_cheer_anim( tank, self );
		//tank thread anim_single_solo( self, "cheer_tank", "tag_origin" );

		wait( 2.7 );
		//link_origin = getent( "ending_reznov_tank_temp", "targetname" );
		//self linkto( link_origin );
		flag_set( "reznov_on_tank" );
		//self anim_loop_solo( self, "rejoice" );
	}
}

reinforce_goal_hero( node )
{
	while( distance( node.origin, self.origin ) > 100 )
	{
		self setgoalnode( node );
		wait( 1 );
	}
}

play_and_loop_cheer_anim( tank, guy )
{
	tank anim_single_solo( guy, "cheer_tank", "tag_origin" );
	tank anim_loop_solo( guy, "cheer_tank_idle", "tag_origin" );
}

ev3_chasing_tank_think( trigger )
{
	wait( 4 );
	trigger notify( "trigger" );
	flag_set( "ev3_flood_spawners_end" );
	wait( 0.5 );
	truck3 = getent( "ending_truck3", "targetname" );
	truck3.health = 99999;
	level notify( "end_truck3_spawns" );
	//level.last_truck = truck3;
	truck3 waittill( "reached_end_node" );
	level notify( "retreat_done_done" );
}


stop_at_reverse_nodes()
{
	back_up_node = getvehiclenode( "ending_backup_node", "script_noteworthy" );
	self setwaitnode( back_up_node );
	self waittill( "reached_wait_node" );
	self setspeed( 0, 10000, 10000 );
	wait( 0.5 );
	self resumespeed( 30 );

	forward_node = getvehiclenode( "ending_backup_node2", "script_noteworthy" );
	self setwaitnode( forward_node );
	self waittill( "reached_wait_node" );
	self setspeed( 0, 10000, 10000 );
	wait( 0.5 );
	self resumespeed( 30 );
}

retreat_tanks()
{
	level waittill( "end_truck1_spawns" );

	wait( 3.5 );

	tanks_spawn = getent( "ev3_escape_tanks_1", "script_noteworthy" );
	tanks_spawn notify( "trigger" );

	wait( 0.5 );

	tank1 = getent( "ending_tank_1", "targetname" );
	tank1.health = 99999;
	tank1.turretrotscale = 1; // slower 


	tank_mounting = getent( "ev3_ending_tanks_ride", "targetname" );
	tank_mounting thread ending_ready_to_mount();

	other_tanks = getentarray( "ev3_ending_tanks", "targetname" );
	for( i = 0; i < other_tanks.size; i++ )
	{
		other_tanks[i] thread ev3_tank_shoot_and_run();
	}

	riding_tank = getent( "ev3_ending_tanks_ride", "targetname" );

	wait( 3 );

	enemy_1 = getent( "ev4_tank1", "targetname" );
	if( isdefined( enemy_1 ) )
	{
		enemy_1 dodamage( enemy_1.health + 100, ( 0, 0, 0 ) );
		enemy_1 notify( "death" );
		//iprintlnbold( "kill1" );
	}

	wait( 2 );

	enemy_2 = getent( "ev4_tank2", "targetname" );
	if( isdefined( enemy_2 ) )
	{
		enemy_2 dodamage( enemy_2.health + 100, ( 0, 0, 0 ) );
		enemy_2 notify( "death" );
		//iprintlnbold( "kill2" );
	}
	
	//riding_tank thread ev3_tank_shoot_and_run();

/*
	tank1 waittill( "reached_end_node" );

	if( isdefined( level.last_truck ) )
	{
		flag_wait( "truck3_unloading" );
		tank1 SetTurretTargetEnt( level.last_truck );
		//tank1 waittill( "turret_on_target" );
		wait( 1 );
		tank1 fireweapon();
		level notify( "last_tank_fires" );
	}
*/
}

ending_ready_to_mount()
{
	self SetCanDamage( false );
	self waittill( "reached_end_node" );
	flag_set( "ending_tank_ready" );
}

retreat_runners()
{
	trigger = getent( "retreat_starts", "targetname" );
	trigger waittill( "trigger" );

	spawners = getentarray( "ev3_runner", "script_noteworthy" );

	while( !flag( "ev3_flood_spawners_end" ) )
	{
		for( i = 0; i < spawners.size; i++ )
		{
			if( !flag( "ev3_flood_spawners_end" ) )
			{
				guy = spawners[i] StalingradSpawn();
				spawn_failed ( guy );
				wait( 0.5 );
			}
		}
		wait( 5 );
	}
}

retreat_final()
{
	flag_wait( "ev3_flood_spawners_end" );

	stop_flood = getent( "ev3_flood_defender_stop", "script_noteworthy" );
	stop_flood notify( "trigger" );
	wait( 0.1 );

	// every enemy near this point shoudl try running away, and die. Others simply die
	axis_ai = GetAiArray( "axis" );
	for( i = 0; i < axis_ai.size; i++ )
	{
		if( isalive( axis_ai[i]	) )
		{
			axis_ai[i] hold_fire();
			if( distance( axis_ai[i].origin, ( -4397, 14715, -65.9 ) ) < 500 )
			{
				axis_ai[i].goalradius = 1;
				axis_ai[i] setgoalpos( -5107, 16123, 97.4698 );
				axis_ai[i] delayed_death( 3 );
			}
			else
			{
				axis_ai[i] delayed_death( 1 );
			}
		}
	}
}

delayed_death( time )
{
	wait( randomfloat( time ) );
	self dodamage( self.health + 100, ( 0, 0, 0 ) );
}

retreat_planes()
{
	level waittill( "end_truck1_spawns" );

	wait( 5.5 );
	level thread ev3_retreat_plane( "ev3_retreat_plane_3", "ev3_retreat_plane_3_mg", "firing_starts_3" );

	wait( 7.5 );
	level thread ev3_retreat_plane( "ev3_retreat_plane_4", "ev3_retreat_plane_4_mg", "firing_starts_4" );
}

load_bombs( bomb_num )
{
	self.bomb_count = bomb_num;
	self.vehicletype = "stuka";

	self.bomb = [];
	for( i = 0; i < self.bomb_count; i++ )
	{
		self.bomb[i] = Spawn( "script_model", ( self.origin ) );
		self.bomb[i] SetModel( level.plane_bomb_model[ self.vehicletype ] );
		self.bomb[i].dropped = false;
		wait(.1);
		if( i % 2 == 0 )
		{
			self.bomb[i] LinkTo( self, "tag_gunLeft", ( 0, 0, -4 ), ( -10, 0, 0 ) );
		}
		else
		{
			self.bomb[i] LinkTo( self, "tag_gunRight", ( 0, 0, -4 ), ( -10, 0, 0 ) );
		}
		
	}
}

// drop bombs when the node is reached
drop_bombs( node_name )
{
	self endon( "death" );

	node = getvehiclenode( node_name, "script_noteworthy" );
	self waittill_vehiclenode( node );

	self thread	maps\_planeweapons::drop_bombs( 2, 0, 2, 500 );
	//iprintlnbold( "BOMB" );
	wait( 0.5 );
	self thread	maps\_planeweapons::drop_bombs( 2, 0, 2, 500 );
	//iprintlnbold( "BOMB" );
	wait( 0.4 );
	self thread	maps\_planeweapons::drop_bombs( 2, 0, 2, 500 );
	//iprintlnbold( "BOMB" );
}

waittill_vehiclenode( node )
{
	self setwaitnode( node );
	self waittill( "reached_wait_node" );
}

//----------------------------------------------------------------------------------

/*
ev3_german_retreat()
{
	// Initially disable triggers. Enable them when the retreat starts
	retreat_triggers = getentarray( "ev3_escape_trigger_camp", "script_noteworthy" );
	for( i = 0; i < retreat_triggers.size; i++ )
	{
		retreat_triggers[i] trigger_off();
	}

	retreat_trigger_spawner_1 = getent( "ev3_escape_trigger_camp_1", "script_noteworthy" );
	retreat_trigger_spawner_1 trigger_off();
	retreat_trigger_spawner_2 = getent( "ev3_escape_trigger_camp_2", "script_noteworthy" );
	retreat_trigger_spawner_2 trigger_off();
	retreat_trigger_spawner_3 = getent( "ev3_escape_trigger_camp_3", "script_noteworthy" );
	retreat_trigger_spawner_3 trigger_off();

	retreat_trigger_flood_1 = getent( "ev3_escape_trigger_camp_flood_1", "script_noteworthy" );
	retreat_trigger_flood_1 trigger_off();
	retreat_trigger_flood_2 = getent( "ev3_escape_trigger_camp_flood_2", "script_noteworthy" );
	retreat_trigger_flood_2 trigger_off();
	retreat_trigger_flood_3 = getent( "ev3_escape_trigger_camp_flood_3", "script_noteworthy" );
	retreat_trigger_flood_3 trigger_off();
	retreat_trigger_flood_4 = getent( "ev3_escape_trigger_camp_flood_4", "script_noteworthy" );
	retreat_trigger_flood_4 trigger_off();
	retreat_trigger_flood_5 = getent( "ev3_escape_trigger_camp_flood_5", "script_noteworthy" );
	retreat_trigger_flood_5 trigger_off();

	level waittill( "both_halftracks_eliminated" );

	level thread ev3_ambient_tank_hits();

	//flag_wait( "ev3_player_passes_barrier" );
	//iprintlnbold( "Germans are retreating" );

	level thread ev3_retreat_initial();

	// Now enable them all
	for( i = 0; i < retreat_triggers.size; i++ )
	{
		retreat_triggers[i] trigger_on();
	}
	retreat_trigger_spawner_1 trigger_on();
	retreat_trigger_spawner_2 trigger_on();
	retreat_trigger_spawner_3 trigger_on();

	retreat_trigger_flood_1 trigger_on();
	retreat_trigger_flood_2 trigger_on();
	retreat_trigger_flood_3 trigger_on();
	retreat_trigger_flood_4 trigger_on();
	retreat_trigger_flood_5 trigger_on();
	retreat_trigger_flood_1 notify( "trigger" );
	retreat_trigger_flood_2 notify( "trigger" );
	retreat_trigger_flood_3 notify( "trigger" );
	retreat_trigger_flood_4 notify( "trigger" );
	retreat_trigger_flood_5 notify( "trigger" );

	// 1. upper path event
	level thread ev3_retreat_upper_path( retreat_trigger_spawner_1 );
	level thread ev3_retreat_lower_path( retreat_trigger_spawner_2 );
	level thread ev3_retreat_final( retreat_trigger_spawner_3 );
}

ev3_retreat_initial()
{
	autosave_by_name( "Camp Taken" );

	existing_enemies = GetAiArray( "axis" );
	for( i = 0; i < existing_enemies.size; i++ )
	{
		if( isalive( existing_enemies[i] ) )
		{
			existing_enemies[i] thread ev3_escaping_german();
		}
	}
}

ev3_retreat_upper_path( spawner_trigger )
{
	spawner_trigger waittill( "trigger" );

	// now the enemies have spawned, wait till the player is looking at the enemies

	wait( 1 );

	look_at_trigger = getent( "ev3_lookat_tent", "targetname" );
	look_at_trigger waittill( "trigger" );

	level thread ev3_retreat_plane( "ev3_retreat_plane_1", "ev3_retreat_plane_1_mg", "ev3_retreat_plane_1_mg_off", "firing_starts_1" );

	level waittill( "firing_starts_1" );
	wait( 0.5 );

	kill_spawner = getent( "ev3_escape_trigger_stop_spawn_1", "targetname" );
	kill_spawner notify( "trigger" );

	existing_enemies = getentarray( "ev3_retreat_secure_1", "script_noteworthy" );
	for( i = 0; i < existing_enemies.size; i++ )
	{
		if( isalive( existing_enemies[i] ) )
		{
			existing_enemies[i] dodamage( existing_enemies[i].health + 100, ( 0, 0, 0 ) );
		}
	}

	//play fx in order

	explosion_1 = getstruct( "ev3_retreat_explode_11", "targetname" );
	explosion_2 = getstruct( "ev3_retreat_explode_12", "targetname" );
	explosion_3 = getstruct( "ev3_retreat_explode_13", "targetname" );
	explosion_4 = getstruct( "ev3_retreat_explode_14", "targetname" );

	playfx( level._effect["dirt_blow_up"], explosion_1.origin );
	wait( 0.5 );
	playfx( level._effect["dirt_blow_up"], explosion_2.origin );

	// if any player is nearby, shellshock him

	players = get_players();
	for( i = 0; i < players.size; i++ )
	{
		if( distance( players[i].origin, explosion_2.origin ) < 700 )
		{
			players[i] shellshock( "tankblast",3 );
		}
	}

	wait( 1 );
	playfx( level._effect["dirt_blow_up"], explosion_3.origin );
	wait( 0.5 );
	playfx( level._effect["dirt_blow_up"], explosion_4.origin );

	wait( 2 );

	//iprintlnbold( "That's our reinforcement. Keep moving!" );
}

ev3_retreat_lower_path( spawner_trigger )
{
	spawner_trigger waittill( "trigger" );

	// now the enemies have spawned, wait till the player is looking at the enemies

	wait( 1 );

	look_at_trigger = getent( "ev3_lookat_lower", "targetname" );
	look_at_trigger waittill( "trigger" );

	level thread ev3_retreat_plane( "ev3_retreat_plane_2", "ev3_retreat_plane_2_mg", "ev3_retreat_plane_2_mg_off", "firing_starts_2" );

	level waittill( "firing_starts_2" );
	wait( 0.5 );

	kill_spawner = getent( "ev3_escape_trigger_stop_spawn_2", "targetname" );
	kill_spawner notify( "trigger" );

	existing_enemies = getentarray( "ev3_retreat_secure_2", "script_noteworthy" );
	for( i = 0; i < existing_enemies.size; i++ )
	{
		if( isalive( existing_enemies[i] ) )
		{
			existing_enemies[i] dodamage( existing_enemies[i].health + 100, ( 0, 0, 0 ) );
		}
	}

	//play fx in order

	explosion_1 = getstruct( "ev3_retreat_explode_21", "targetname" );
	explosion_2 = getstruct( "ev3_retreat_explode_22", "targetname" );
	explosion_3 = getstruct( "ev3_retreat_explode_23", "targetname" );
	explosion_4 = getstruct( "ev3_retreat_explode_24", "targetname" );

	playfx( level._effect["dirt_blow_up"], explosion_1.origin );
	wait( 0.5 );
	playfx( level._effect["dirt_blow_up"], explosion_2.origin );

	// if any player is nearby, shellshock him

	players = get_players();
	for( i = 0; i < players.size; i++ )
	{
		if( distance( players[i].origin, explosion_2.origin ) < 700 )
		{
			players[i] shellshock( "tankblast",3 );
		}
	}

	wait(0.5 );
	playfx( level._effect["dirt_blow_up"], explosion_3.origin );
	wait( 0.5 );
	playfx( level._effect["dirt_blow_up"], explosion_4.origin );

	wait( 2 );

	//iprintlnbold( "That's our reinforcement. Keep moving!" );
}


*/

ev3_retreat_final( spawner_trigger )
{
	spawner_trigger waittill( "trigger" );
	level notify( "final_retreat" );
	// now the enemies have spawned, wait till the player is looking at the enemies

	wait( 3 );

	level thread ev3_retreat_final_plane1();
	wait( 2 );
	level thread ev3_retreat_final_plane2();
	level thread ev3_retreat_final_tanks1();
	level thread ev3_retreat_final_tanks2();
}

ev3_retreat_final_plane1()
{
	//level thread ev3_retreat_plane( "ev3_retreat_plane_3", "ev3_retreat_plane_3_mg", "ev3_retreat_plane_3_mg_off", "firing_starts_3" );

	level waittill( "firing_starts_3" );
	wait( 1 );

	explosion_1 = getstruct( "ev3_retreat_explode_31", "targetname" );
	explosion_2 = getstruct( "ev3_retreat_explode_32", "targetname" );

	playfx( level._effect["dirt_blow_up"], explosion_1.origin );
	wait( 1 );
	playfx( level._effect["dirt_blow_up"], explosion_2.origin );
}

ev3_retreat_final_plane2()
{
	//level thread ev3_retreat_plane( "ev3_retreat_plane_4", "ev3_retreat_plane_4_mg", "ev3_retreat_plane_4_mg_off", "firing_starts_4" );

	level waittill( "firing_starts_4" );
	wait( 1 );

	explosion_1 = getstruct( "ev3_retreat_explode_41", "targetname" );
	explosion_2 = getstruct( "ev3_retreat_explode_42", "targetname" );
	explosion_3 = getstruct( "ev3_retreat_explode_43", "targetname" );

	playfx( level._effect["dirt_blow_up"], explosion_1.origin );
	wait( 1 );
	playfx( level._effect["dirt_blow_up"], explosion_2.origin );
	wait( 0.5 );
	playfx( level._effect["dirt_blow_up"], explosion_3.origin );
}

ev3_retreat_final_tanks1()
{
	spawn_trigger = getent( "ev3_escape_tanks_1", "script_noteworthy" );
	spawn_trigger notify( "trigger" );

	wait( 1.5 );

	tanks = getentarray( "ev3_ending_tanks", "targetname" );
	tanks_special = getent( "ev3_ending_tank1", "targetname" );

	for( i = 0; i < tanks.size; i++ )
	{
		tanks[i] thread ev3_tank_shoot_and_run();
	}

	tanks_special thread ev3_end_tank_1();
}

ev3_retreat_final_tanks2()
{
	wait( 3 );
	spawn_trigger = getent( "ev3_escape_tank", "script_noteworthy" );
	spawn_trigger notify( "trigger" );
}

ev3_tank_shoot_and_run()
{
	level endon( "retreat_done_done" );
	while( 1 )
	{
		wait( randomint( 4 ) + 3 );
		self FireWeapon();
	}
}

ev3_end_tank_1()
{
	node_fire = getvehiclenode( "ev3_tank_end_turret", "script_noteworthy" );
	self setwaitnode( node_fire );
	self waittill( "reached_wait_node" );	

	// stop flood spawner
	stop_flood = getent( "ev3_escape_trigger_stop_spawn_3", "targetname" );
	stop_flood notify( "trigger" );

	explosion_1 = getent( "ev3_retreat_explode_51", "targetname" );
	explosion_2 = getent( "ev3_retreat_explode_52", "targetname" );
	
	self SetTurretTargetEnt( explosion_1 );
	self waittill( "turret_on_target" );
	self FireWeapon();
	playfx( level._effect["tank_blow_up"], explosion_1.origin );

	wait( 2 );
	self SetTurretTargetEnt( explosion_2 );
	self waittill( "turret_on_target" );
	self FireWeapon();
	playfx( level._effect["house_blow_up"], explosion_2.origin );


	explosion_3 = getstruct( "ev3_retreat_explode_53", "targetname" );
	explosion_4 = getstruct( "ev3_retreat_explode_54", "targetname" );
	explosion_5 = getstruct( "ev3_retreat_explode_55", "targetname" );

	//exploder( 4999 );

	playfx( level._effect["tree_brush_fire"], explosion_3.origin );
	playfx( level._effect["tree_brush_fire"], explosion_4.origin );
	playfx( level._effect["tree_brush_fire"], explosion_5.origin );

	existing_enemies = GetAiArray( "axis" );
	for( i = 0; i < existing_enemies.size; i++ )
	{
		if( isalive( existing_enemies[i] ) )
		{
			existing_enemies[i] dodamage( existing_enemies[i].health + 100, ( 0, 0, 0 ) );
		}
	}

	players = get_players();
	for( i = 0; i < players.size; i++ )
	{
		if( distance( players[i].origin, explosion_5.origin ) < 700 )
		{
			players[i] shellshock( "tankblast",3 );
		}
	}

	wait( 3 );
	level notify( "retreat_done" );

	trigger = getent( "to_train_station", "targetname" );
	trigger waittill( "trigger" );

	level notify( "retreat_done_done" );
}

ev3_retreat_plane( node_name, bomb_drop_start, msg )
{
	start_node = getvehiclenode( node_name, "targetname" );

	plane = spawnvehicle( "vehicle_rus_airplane_il2", 
						 "plane", 
						 "stuka", 
						 start_node.origin, 
						 start_node.angles );		

	plane attachPath( start_node );
	plane startpath();
	plane.script_numbombs = 6;
	
	plane playsound( "fly_by3" );
	
	//Kevin Sending ent name to the client side
	//plane_guns = getentarray("plane", "targetname");
	//for(i = 0; i < plane_guns.size; i ++)
	//{
	//	plane_guns[i] transmittargetname();
	//}

	plane thread load_bombs( 6 );	
	wait( 0.7 );
	plane thread drop_bombs( bomb_drop_start );

	plane waittill( "reached_end_node" );
	plane delete();

}

ev3_escaping_german()
{
	self endon( "death" );
	self hold_fire();
	self.goalradius = 64;
	self.ignoreme = true;
	self.pacifist = 1;
	self.ignoreall = 1;
	self.animname = "generic";
	//self assign_random_retreat_anim();

	escape_nodes = getnodearray( "ev3_escape_nodes", "targetname" );
	node = escape_nodes[randomint( escape_nodes.size )];

	self thread goal_attack_to_close_player();
	self thread tracers_and_blood_damage( node );

	if( distance( node.origin, self.origin ) > 1500 )
	{
		wait( randomfloat( 1.0 ) );
		self doDamage( self.health + 25, ( 0,180,48 ) );
		return;
	}

	self setgoalpos( node.origin );
	self thread ev3_retreat_random_death( node.origin );
	// kill himself once there
	self waittill( "goal" );
	self set_random_gib();
	self doDamage( self.health + 25, ( 0,180,48 ) );
}

ev3_escaping_german_delay()
{
	self endon( "death" );

	wait( 5 );
	self thread ev3_escaping_german();
}

ev3_retreat_random_death( goal_origin )
{
	self endon( "death" );
	old_pos = self.origin;
	self.health = 5;
	// see if the ai moves in 2 seconds
	wait( 4 );
	if( distance( old_pos, self.origin ) < 32 )
	{
		wait( randomfloat( 1 ) );
		self dodamage( self.health + 100, ( 0, 0, 0 ) );
		return;
	}
	
	// check to make sure the AI is half way at least to the goal
	half_dist = distance( old_pos, goal_origin ) * 0.5;
	
	while( distance( self.origin, goal_origin ) > half_dist )
	{
		wait( 0.1 );
	}

	// now we can kill them
	wait( randomfloat( 6 ) );

	self set_random_gib();
	self dodamage( self.health + 100, ( 0, 0, 0 ) );
}


ev3_initial_planes()
{
	trigger1 = getent( "ev3_opel_spawn", "targetname" );
	trigger1 waittill( "trigger" );
	//level thread ev3_retreat_plane( "ev3_initial_plane_1", "ev3_initial_plane_1_mg", "ev3_initial_plane_1_mg_off", "firing_starts_11" );

	level thread dialog_enter_compound();

	trigger2 = getent( "ev3_opel_move", "targetname" );
	trigger2 waittill( "trigger" );
//	level thread ev3_retreat_plane( "ev3_initial_plane_2", "ev3_initial_plane_2_mg", "ev3_initial_plane_2_mg_off", "firing_starts_12" );
}

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
/* AI Script: Destructible opel trucks

	Use: thread ev3_destructible_truck_death_run on a truck

	- Truck cannot be destroyed until it has at least passed the "safe_node"
	- Truck have 3 damage states. If keep taking damage, it will start releasing
	  smoke, then fire, then blows up
	- Explosion damage will auomatically set the truck ablaze, though it won't blow 
	  up immediately if "safe_node" has not been passed
	- AIs on truck play drive_reaction anims automatically, and fire death anim
      if truck catches on fire
*/
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

	ev3_destructible_truck_death_run( stop_msg, safe_point_snw )
	{
		self endon( "death" );
		// The truck is always set at health 99999, invincible. We keep track of
		// how many times the player has hit the truck, to determine when it dies
		self.virtual_health_state = 3;  // 3=undamaged
										// 2=light_smoke, 1=heavy_smoke, 0=dead_blowup
		self.health = 99999;
		
		self thread dont_fire_when_unloading();
		self thread open_door_when_exit();
	
		self thread check_pass_end_point( stop_msg );
		self thread check_pass_safe_point( safe_point_snw );
		self thread check_for_helath_state();
		self thread force_reaction_anim_truck( stop_msg );
	
		self waittill( "passed_safe_point" );
	
		while( self.virtual_health_state > 0 )
		{
			wait( 0.1 );
		}
	
		playFxOnTag( level._effect["tree_brush_fire"], self, "tag_driver" );
		// kill passengers here
		level notify( stop_msg );
	
		self setspeed( 0, 10, 10 );
		self notify( "time_to_fire_death" );
	
		wait( 1 );
		self.health = 1;
		
		if( isdefined( self.attacker_player ) )
		{
			attached_guys = self.attachedguys;
			alive_guys = 0;
			for( i = 0; i < attached_guys.size; i++ )
			{
				if( isalive( attached_guys[i] ) )
				{
					alive_guys++;
				}
			}

			if( alive_guys == 1 )
			{
				arcademode_assignpoints( "arcademode_score_generic50", self.attacker_player );
			}
			else if( alive_guys == 2 )
			{
				arcademode_assignpoints( "arcademode_score_generic100", self.attacker_player );
			}
			else if( alive_guys == 3 || alive_guys == 4 )
			{
				arcademode_assignpoints( "arcademode_score_generic250", self.attacker_player );
			}
			else if( alive_guys > 4 )
			{
				arcademode_assignpoints( "arcademode_score_generic500", self.attacker_player );
			}

			self dodamage( self.health + 100, ( 0, 0, 0 ) );
			self notify( "death", self.attacker_player );
		}
		else
		{
			self dodamage( self.health + 100, ( 0, 0, 0 ) );
			self notify( "death" );
		}
	}

	#using_animtree ("vehicles");
	open_door_when_exit()
	{
		self endon( "death" );
		
		self waittill( "open_door_climbout" );
/*
		new_model = spawn( "script_model", self.origin );
		new_model.angles = self.angles;
		new_model setmodel( "vehicle_ger_wheeled_opel_blitz" );
		//new_model setmodel( "vehicle_ger_wheeled_opel_blitz" );
		new_model useanimtree( #animtree );
		new_model.animname = "opel";
		new_model anim_single_solo( new_model, "truck_door_open" );
		//dest_opel_blitz_full
*/

		self useanimtree( #animtree );
		self.animname = "opel";
		self anim_single_solo( self, "truck_door_open" );
	}

	#using_animtree ("generic_human");
	dont_fire_when_unloading()
	{
		self endon( "death" );
		self endon( "unload" );
		self waittill( "time_to_fire_death" );
		//self notify( "groupedanimevent", "death_fire" );
	}
	check_pass_end_point( end_msg )
	{
		self endon( "death" );
		self waittill( "reached_end_node" );
		level notify( end_msg );
	}
	
	check_pass_safe_point( safe_point_snw )
	{
		self endon( "death" ); // though this should not really happen
		node_safe = getvehiclenode( safe_point_snw, "script_noteworthy" );
		self setwaitnode( node_safe );
		self waittill( "reached_wait_node" );	
		
		self notify( "passed_safe_point" );
	}
	
	check_for_helath_state()
	{
		self endon( "death" );
		
		self.virtual_health_state = 3;
	
		while( 1 )
		{
			self waittill( "damage", amount, attacker, direction_vec, point, type );
	
			// These damage always count
			if( type == "MOD_PROJECTILE_SPLASH" || type == "MOD_PROJECTILE" || type == "MOD_GRENADE" || type == "MOD_GRENADE_SPLASH" )
			{
				playFxOnTag( level._effect["engine_smoke_heavy"], self, "tag_driver" );
				self.virtual_health_state = 0;
				return;
			}
	
			else
			{
				// otherwise, only player damage count
				if( isplayer( attacker ) )
				{
					self.virtual_health_state--;
					
					if( self.virtual_health_state == 2 )
					{
						playFxOnTag( level._effect["engine_smoke_light"], self, "tag_driver" );
					}
					else if( self.virtual_health_state == 1 )
					{
						playFxOnTag( level._effect["engine_smoke_heavy"], self, "tag_driver" );
					}
					else if( self.virtual_health_state == 0 )
					{
						self.attacker_player = attacker;
						return;
					}	
					wait( 0.5 );
				}
			}
			self.health = 99999;
		}
	}
	
	force_reaction_anim_truck( end_msg )
	{
		level endon( end_msg );
		self endon( "death" );
	
		animlength = getanimlength( %crew_truck_guy1_drive_reaction );
		time = animlength * 1000;
	
		while( 1 )
		{
			self notify( "groupedanimevent", "drive_reaction" );
			//wait( time );
			wait( 2 );
		}
	}


//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
/* AI Script: Destructible Towers

	Use: thread ev3_tower_event using a tower name

	- Tower will loop panzershreck fires at specified targets
	- Tower should have an exploder trigger. When triggered, the firing stops
	- A T34 spawns and moves (trigger or notify based), loops firing at a target,
	  and gets destroyed by the tower at end node. (Unless tower is already destroyed)
	- Tower can be forced to blow up by notify

	Ex: tower_name = "tower1"

	script_noteworthy - "tower1"		Exploder trigger (trigger)
	script_noteworthy - "tower1_start"	Shreck start pos (struct)
	script_noteworthy - "tower1_end"	Shreck end pos, can have multiple (struct)
	script_noteworthy - "tower1_move_tank"  Trigger that spawns and moves tank (trigger)
	targetname - "tower1_tank"		Tank (ent)
	targetname - "tower1_fire_at"   Tank's fire at position (script origin)

	"tower1_blows_up"	Msg to level when tower blows up
	"tower1_tank_stop"	Msg to level when tank reaches end node
	"tower1_tank_spawned"  Msg to force the tank to spawn and move, without trigger
	"tower1_force_blow_up" Msg to force the tower to blow up
*/
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

	ev3_tower_event( tower_name, shreck )
	{
		// when the tower blows up, this will be triggered
		exploder_trigger = getent( tower_name, "script_noteworthy" );
	
		// notify to send out when the tower blows up
		blow_up_msg = tower_name + "_blows_up";


		if( isdefined( shreck ) && shreck == true )
		{
			level thread ev3_tower_event_panzershreck_loop( tower_name, blow_up_msg );
		}

		level thread ev3_tower_event_force_blow_up( tower_name, exploder_trigger );

		level thread ev3_tower_event_ai_spawn( tower_name, blow_up_msg );
	
		// see if tank spawn exists
		/*
		tank_spawn_trigger_name = tower_name + "_move_tank";
		spawn_trigger = getent( tank_spawn_trigger_name, "script_noteworthy" );
		
		if( isdefined( spawn_trigger ) )
		{
			// notify to send out when the tank is in position
			tank_stops_msg = tower_name + "_tank_stop";
	
			level thread ev3_tower_event_spawn_t34( tower_name, spawn_trigger, tank_stops_msg );
			level thread ev3_tower_event_blow_up_t34( tower_name, blow_up_msg, tank_stops_msg );
		}
		*/

		exploder_trigger waittill( "trigger" );
		level notify( blow_up_msg );
	}

	ev3_tower_event_ai_spawn( tower_name, blow_up_msg )
	{	
		level waittill( "blow_up_msg" );

		if( tower_name == "tower4" )
		{
			trigger = getent( "tower_2_guy_spawn_trig", "targetname" );
			trigger trigger_off();

			spawner = getent( "ev3_tower_guys2", "script_noteworthy" );
			if( isdefined( spawner ) )
			{
				spawner.count = 0;
			}
		}
		else if( tower_name == "tower5" )
		{
			trigger = getent( "tower_3_guy_spawn_trig", "targetname" );
			trigger trigger_off();

			spawner = getent( "ev3_tower_guys3", "script_noteworthy" );
			if( isdefined( spawner ) )
			{
				spawner.count = 0;
			}
		}
		/*
		spawner_name = tower_name + "_spawner";
		spawner = getent( spawner_name, "targetname" );

		if( !isdefined( spawner ) )
		{
			return;
		}

		spawnedGuy = spawner StalingradSpawn();
		spawn_failed (spawnedGuy);
		iprintlnbold( "spawned " + tower_name );
		level thread track_spawned_tower_guy_death( spawnedGuy, tower_name );
		level waittill( blow_up_msg );

		if( isalive( spawnedGuy ) )
		{
			spawnedGuy dodamage( spawnedGuy.health + 100, (0,0,0) );
			//spawnedGuy delete();
		}*/

		
	}

	track_spawned_tower_guy_death( guy, tower_name )
	{
		guy waittill( "death" );
		//iprintlnbold( "killed " + tower_name );
	}

	ev3_tower_event_tracers_loop( tower_name, blow_up_msg )
	{
		// structs that tower fires from/to
		fire_start_name = tower_name + "_start";
		fire_end_name = tower_name + "_end";
	
		fire_start = getstruct( fire_start_name, "script_noteworthy" );
		fire_ends = getstructarray( fire_end_name, "script_noteworthy" );
		
		// when the tower blows up, stop
		level endon( blow_up_msg );
		level endon( "both_halftracks_eliminated" );

		while( 1 )
		{
			end_origin = fire_ends[randomint( fire_ends.size )].origin;
			end_origin = end_origin + ( 150-randomint(300), 150-randomint(300), 25-randomint(50) );
			play_burst_fake_fire( 20, fire_start.origin, end_origin );
	
			wait( randomfloat( 6 ) + 2 );
		}
	}

	
	ev3_tower_event_panzershreck_loop( tower_name, blow_up_msg )
	{
		// structs that tower fires from/to
		fire_start_name = tower_name + "_start";
		fire_end_name = tower_name + "_end";
	
		fire_start = getstruct( fire_start_name, "script_noteworthy" );
		fire_ends = getstructarray( fire_end_name, "script_noteworthy" );
		
		// when the tower blows up, stop
		level endon( blow_up_msg );
		level endon( "both_halftracks_eliminated" );

		while( 1 )
		{
			wait( randomfloat( 3 ) );
			fire_origin = fire_ends[randomint( fire_ends.size )].origin;
			fire_origin = fire_origin + ( 400 - randomint(800), 400 - randomint(800), 0 );
			level thread fire_shreck_at_pos( fire_start, fire_origin, 1 );
	
			wait( randomfloat( 3 ) + 2 );
		}
	}
	
	ev3_tower_event_spawn_t34( tower_name, spawn_trigger, tank_stops_msg )
	{
		// spawn t34 by either hitting trigger or notify level tower_name+"_tank_spawned"
		level thread ev3_tower_event_spawn_t34_trigger_wait( tower_name, spawn_trigger );
		tank_spawn_msg = tower_name + "_tank_spawned";
		level waittill( tank_spawn_msg );
	
		wait( 1 );
	
		tank_name = tower_name + "_tank";
		tank = getent( tank_name, "targetname" );
		tank endon( "death" );
	
		tank thread ev3_tower_event_t34_fire_loop( tower_name );
		
		tank waittill( "reached_end_node" );
		level notify( tank_stops_msg );
	}
	
	ev3_tower_event_spawn_t34_trigger_wait( tower_name, spawn_trigger )
	{
		spawn_trigger waittill( "trigger" );
		
		tank_spawn_msg = tower_name + "_tank_spawned";
		level notify( tank_spawn_msg );
	}
	
	ev3_tower_event_t34_fire_loop( tower_name )
	{
		self endon( "death" );
	
		fire_at_target_name = tower_name + "_fire_at";
		fire_at_target = getent( fire_at_target_name, "targetname" );
		self SetTurretTargetEnt( fire_at_target );
	
		while( 1 )
		{
			wait( 0.3 );
			self FireWeapon();
			playfx( level._effect["tank_fire_dust"],self.origin );
			wait( randomfloat( 3 ) + 3 );
		}
	}
	
	ev3_tower_event_blow_up_t34( tower_name, blow_up_msg, tank_stops_msg )
	{
		fire_start_name = tower_name + "_start";
		fire_start = getstruct( fire_start_name, "script_noteworthy" );
	
		level endon( blow_up_msg );
	
		level waittill( tank_stops_msg );
	
		tank_name = tower_name + "_tank";
		tank = getent( tank_name, "targetname" );
		if( isdefined( tank ) && isalive( tank ) )
		{
			level thread fire_shreck( fire_start, tank, 1 );
			wait( 1 );
			playfx( level._effect["tank_blow_up"], tank.origin );
			tank notify( "death" );
		}
	}
	
	ev3_tower_event_force_blow_up( tower_name, exploder_trigger )
	{
		force_blowup_msg = tower_name + "_force_blow_up";
		level waittill( force_blowup_msg );
		
		if( isdefined( exploder_trigger ) )
		{
			exploder_trigger notify( "trigger" );
		}
	}

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

ev3_ambient_tank_hits()
{
	level endon( "retreat_done_done" );
	friendly_targets = getstructarray( "ev3_camp_amb_explosion", "targetname" );
	while( 1 )
	{
		index = randomint( friendly_targets.size );
		playfx( level._effect["dirt_blow_up"], friendly_targets[index].origin );

		wait( randomfloat( 2 ) );
	}
}


dialog_reach_compound()
{
	level.hero2 say_dialogue( "chernov", "path_blocked" );
	level.hero1 say_dialogue( "reznov", "find_around" );
	level.hero1 say_dialogue( "reznov", "this_is_it" );
	//level.hero1 say_dialogue( "reznov", "final_push" );
	//level.hero1 say_dialogue( "reznov", "revel_victory" );
	level.hero1 say_dialogue( "reznov", "charge" );

	wait( 5 );

	level.hero1 say_dialogue( "reznov", "revel_victory" );
}

dialog_enter_compound()
{
	level.hero1 say_dialogue_wait( "reznov", "down_towers" );
	level.hero1 say_dialogue_wait( "reznov", "use_panzer" );

	wait( 4 );

	level.hero1 say_dialogue_wait( "reznov", "find_rockets" );
	level.hero1 say_dialogue_wait( "reznov", "bring_down_towers" );
}

dialog_halftracks()
{
	spawn_trigger = getent( "ev3_halftracks_move", "targetname" );
	spawn_trigger waittill( "trigger" );

	level.hero1 say_dialogue( "reznov", "halftrack" );
	wait( 2 );
	//level.hero1 say_dialogue_wait( "reznov", "strongest_weapon" );
	//level.hero1 say_dialogue( "reznov", "mg_halftrack" );
	//wait( 3 );
	//level.hero1 say_dialogue( "reznov", "bullet_head" );
}

dialog_halftracks_1_eliminated()
{
	level.hero1 say_dialogue_wait( "reznov", "weakening" );
	level.hero1 say_dialogue( "reznov", "finish_them" );
}

dialog_tower_2_cleared()
{
	level waittill( "tower2_blows_up" );
	level.hero1 say_dialogue_wait( "reznov", "follow_example" );
}

dialog_tower_4_cleared()
{
	level waittill( "tower4_blows_up" );
	level.hero1 say_dialogue_wait( "reznov", "destroy_towers" );
}

dialog_truck_road_shoot()
{
	//level.hero2 say_dialogue( "chernov", "reinforcements" );
	level.hero1 say_dialogue( "chernov", "trucks_approaching" );
	level.hero1 say_dialogue( "reznov", "blow_pieces" );
	//level waittill( "ev3_truck_special_stop" );
	//level.hero1 say_dialogue_wait( "reznov", "greatest_asset" );
}

dialog_germans_retreating()
{	
	level.hero2 say_dialogue( "chernov", "pulling_back" );
	level.hero1 say_dialogue( "reznov", "matters_die" );
	level.hero1 say_dialogue( "reznov", "hunt_down" );
	//level.hero2 say_dialogue( "chernov", "ready_surrender" );
	//level.hero1 say_dialogue( "reznov", "not_ready_let" );
	level.hero1 say_dialogue( "reznov", "no_mercy_shown" );
	level.hero1 say_dialogue( "reznov", "no_mercy_here" );
	level.hero1 say_dialogue( "reznov", "eye_for_eye" );
}

dialog_germans_running()
{
	//level.hero1 say_dialogue( "reznov", "victory_at_hand" );
}

dialog_last_charge()
{
	trigger = getent( "retreat_starts", "targetname" );
	trigger waittill( "trigger" );
	level.hero1 say_dialogue( "reznov", "victory_at_hand" );
	level.hero1 say_dialogue( "reznov", "cockroaches" );
}

dialog_last_charge2()
{
	//TUEY Set Music State to End Level
	setmusicstate("END_LEVEL");

	level.hero1 say_dialogue( "reznov", "from_this_moment_on" );
	//level notify( "last_dialog_done" );
}


