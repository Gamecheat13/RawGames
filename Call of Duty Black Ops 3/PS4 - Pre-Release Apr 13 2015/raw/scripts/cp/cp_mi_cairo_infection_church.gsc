#using scripts\codescripts\struct;

#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\hud_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\cp\_dialog;
#using scripts\cp\_mobile_armory;
#using scripts\cp\_objectives;
#using scripts\cp\_skipto;
#using scripts\cp\_spawn_manager;
#using scripts\cp\_util;

#using scripts\cp\cp_mi_cairo_infection_util;
#using scripts\cp\cp_mi_cairo_infection_village_surreal;

                                               	                                                          	              	                                                                                           
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       




#namespace church;

// ----------------------------------------------------------------------------
// init_client_field_callback_funcs
// ----------------------------------------------------------------------------
function init_client_field_callback_funcs()
{
	clientfield::register( "world", "light_church_int_cath_all", 	1, 1, "int" );
}

function cleanup_church( str_objective, b_starting, b_direct, player )
{
	array::thread_all(level.players, &infection_util::player_leave_cinematic );
}

function cleanup_cathedral( str_objective, b_starting, b_direct, player )
{
	infection_util::enable_exploding_deaths( false );

	array::thread_all(level.players, &infection_util::player_leave_cinematic );
		
	//adding cleanup here incase a skipto was used.	
	level thread all_remaining_enemies_die_off();
	
}

function main_church( str_objective, b_starting )
{	
	if ( b_starting )
	{		
		init_church();
		
		ai_objective_sarah = util::get_hero( "sarah" );
		ai_objective_sarah thread scene::play( "cin_inf_11_04_fold_vign_walk_end", ai_objective_sarah );	
	}
	
	level flag::wait_till( "all_players_spawned" );
	
	array::thread_all(level.players, &infection_util::player_enter_cinematic );	
			
	church_scene_setup();
	
	church_doors_close();
	
	wait 5; // wait a little after the doors are closed before the tank burst into the scene.
	
	tiger_tank_drives_into_church();
}

function main_cathedral( str_objective, b_starting )
{	
	setup_spawners();
	cathedral_scene_setup();	
	
	trig = GetEnt( "cathedral_sarah_at_altar", "targetname" );
	trig triggerenable( false );
	
	exploder::exploder( "fx_light_cathedral_lightning" );	
	
	if ( b_starting )
	{
		level flag::wait_till( "all_players_spawned" );
		
		spawn_quad_tank();	
	}

	//adding back enemy ai for coop. 
	if( level.players.size > 0 )
	{		
		battle_in_cathedral();
	}

	level flag::wait_till( "cathedral_quad_tank_destroyed" );
	
	objectives::complete( "cp_level_infection_destroy_quadtank" );

	wait_enemy_cleared();

	sarah_appears();
	
	wait_for_players_to_approach_sarah();
	
	sarah_vignette_in_cathedral();
	
	floor_breaks_away(); //now handles moving to next scene(s)

}

// ----------------------------------------------------------------------------
// DIALOG: vo quad tank birth
// ----------------------------------------------------------------------------
function vo_intro_quad_tank()
{
	level dialog::player_say( "plyr_what_the_fuck_0", 1.0 ); //What the FUCK??
	level.players[0] thread dialog::say( "hall_brute_force_somet_0", 0.0 ); //Brute force... Sometimes that’s all that’s left... All you have.
}

function dev_cathedral_outro( str_objective, b_starting )
{
	level flag::init( "sarah_distance_objective" );
	
	level thread cathedral_scene_setup();
	
	sarah_appears();
	
	wait_for_players_to_approach_sarah();
	
	sarah_vignette_in_cathedral();

	level thread skipto::objective_completed( "dev_cathedral_outro" );			
	floor_breaks_away(); //now handles moving to next scene(s)
}

function dev_cathedral_outro_cleanup( str_objective, b_starting, b_direct, player )
{
}

function setup_spawners()
{
	spawner::add_spawn_function_group( "sm_cathedral_guys", "script_noteworthy", &infection_util::set_goal_on_spawn );
	spawner::add_spawn_function_group( "sm_cathedral_guys", "script_noteworthy", &ai_accuracy );

	infection_util::enable_exploding_deaths( true );
	
	// quad tank setup
	level flag::init( "cathedral_quad_tank_destroyed" );
	level flag::init( "sarah_distance_objective" );
}

function init_church()
{
	scene::add_scene_func( "p7_fxanim_cp_infection_church_explode_01_bundle", &scene_func_fxanim_church_setup, "init" );
	
	scene::init( "p7_fxanim_cp_infection_church_explode_01_bundle" );
	
	level clientfield::set( "light_church_int_cath_all", 1 );
}

function scene_func_fxanim_church_setup( a_ents )
{
	a_ents[ 0 ] SetForceNoCull();  // a_ents[ 0 ] = church model. TODO: set this up with a specific model name so it doesn't read like a hack
}

function get_quad_tank_spawner()
{
	a_quad_tanks = GetEntArray( "quad_tank_cathedral", "script_noteworthy" );
	
	sp_quad_tank = undefined;
	
	foreach ( ent in a_quad_tanks )
	{
		if ( IsSpawner( ent ) )
		{
			sp_quad_tank = ent;
		}
	}
	
	return sp_quad_tank;
}

function spawn_quad_tank( e_reference )
{
	sp_quad_tank = get_quad_tank_spawner();
	
	vh_quad_tank = spawner::simple_spawn_single( sp_quad_tank, &spawn_func_quad_tank_death );
	
	if ( IsDefined( e_reference ) )
	{
		// quad tank needs to animate where the old tank used to be, so teleport it there and start animating
		vh_quad_tank.origin = e_reference.origin;
		vh_quad_tank.angles = e_reference.angles; 
	}
	
	scene::add_scene_func("cin_inf_11_05_fold_vign_qtbirth", &scene_qtbirth_end , "done" );
	level thread scene::play( "cin_inf_11_05_fold_vign_qtbirth", vh_quad_tank );	
	scene::add_scene_func("cin_inf_11_05_fold_vign_tigertank", &scene_tigertank_end , "done" );
	level thread scene::play( "cin_inf_11_05_fold_vign_tigertank" );	

	level thread vo_intro_quad_tank();

		
	e_goal_volume = GetEnt( "quadtank_goal_volume", "targetname" );
	vh_quad_tank SetGoal( e_goal_volume );
}

function scene_qtbirth_end ( a_ent )
{
	level notify( "scene_qtbirth_end" );
}

function scene_tigertank_end( a_ent )
{
		vh_tank = a_ent[ "tiger_tank_cinematic" ];
		
		vh_tank NotSolid();
}

// ----------------------------------------------------------------------------
// Quadtank death or hack watcher
// ----------------------------------------------------------------------------
function spawn_func_quad_tank_death()
{
	self thread quadtank_hijack_watcher();
	self thread quadtank_death_watcher();

	self thread quadtank_trophy_system_watcher();
	
	self thread church_pillars_explode_fxanim();
	
	self thread destroy_quadtank_objective();

	level util::waittill_any( "quadtank_dead", "quadtank_hijack_complete" );
	level notify( "quadtank_destroyed" );
	
	level flag::set( "cathedral_quad_tank_destroyed" );
	
}

function quadtank_hijack_watcher()
{
	level endon( "quadtank_destroyed" );
	
	level waittill("ClonedEntity",clone,vehEntNum);
	if(!isdefined(clone))
	{	
		level notify( "quadtank_hijack_complete" );	
	}

	//when player exits the quadtank it dies
	clone waittill( "death" );

	level notify( "quadtank_hijack_complete" );	
}

function quadtank_death_watcher()
{
	self endon( "CloneAndRemoveEntity" );
	
	self waittill( "death" );

	level notify( "quadtank_dead" );
}

function quadtank_trophy_system_watcher()
{
	self endon( "death" );

	while( true )
	{	
		self util::waittill_either( "trophy_system_disabled", "trophy_system_destroyed" );

		//send ai to protect
		ai_enemy = spawn_manager::get_ai( "sm_cathedral_lower" );
		for( i=0; i<ai_enemy.size; i++ )
		{			
			if ( i<5 && ( Distance2DSquared( self.origin, ai_enemy[i].origin ) > ( 200 * 200 ) ) )
			{
				self thread follow_quad_tank( ai_enemy[i] );
			}		
		}	
		
		self waittill( "trophy_system_enabled" );
		//return ai to original goal volumes.
		ai_enemy = spawn_manager::get_ai( "sm_cathedral_lower" );
		for( i=0; i<ai_enemy.size; i++ )
		{
			ai_enemy[i] ClearForcedGoal();
		}			
	}
}

// self = quadtank
function church_pillars_explode_fxanim()
{
	self endon( "death" );
	
	self thread qt_shoot_at_pillar( "church_pillars_explode_01", "p7_fxanim_cp_infection_church_pillars_explode_01_bundle" );
	self thread qt_shoot_at_pillar( "church_pillars_explode_02", "p7_fxanim_cp_infection_church_pillars_explode_02_bundle" );
	self thread qt_shoot_at_pillar( "church_pillars_explode_03", "p7_fxanim_cp_infection_church_pillars_explode_03_bundle" );
	self thread qt_shoot_at_pillar( "church_pillars_explode_04", "p7_fxanim_cp_infection_church_pillars_explode_04_bundle" );
	
}

function qt_shoot_at_pillar( e_trig, fxanim_name )
{
	self endon( "death" );
	
	trigger::wait_till( e_trig );
	
	trig = GetEnt( e_trig, "targetname" );
	e_target = Spawn( "script_origin", trig.origin );	
	//self thread ai::shoot_at_target( "normal", e_target, undefined, 1 );
	
	self SetTurretTargetEnt( e_target );
	self waittill( "turret_on_target" );	
	self FireWeapon( 0, e_target );
	
	level scene::play( fxanim_name, "scriptbundlename" );   // church pillars explode fxanim	
}

// self == quadtank
function follow_quad_tank( ai )
{
	self endon ( "trophy_system_enabled" );
	self endon ( "death" );
	ai endon ("death" );
	
	n_min_dist = 150;
	n_max_dist = 350;
	n_max_height = 48;
			
	while ( true )
	{
		a_v_points = GetNavPointsInRadius( self.origin, n_min_dist, n_max_dist, 100, 32, n_max_height );
		
		if( isdefined( a_v_points ) )
		{
			ai SetGoal( array::random(a_v_points), true );	
		}
		
		wait RandomFloatRange( 0.5, 1 );  //don't want AIs all moving at once
	}	       
}

function destroy_quadtank_objective()
{
	level waittill( "scene_qtbirth_end" );
	objectives::set( "cp_level_infection_destroy_quadtank" , self );
}


// ----------------------------------------------------------------------------
function church_scene_setup()
{
	level flag::init( "church_warp_ready" );
	
	// fxanims
	scene::add_scene_func( "p7_fxanim_cp_infection_church_explode_01_bundle", &scene_callback_tank_start_1, "play" );
	scene::add_scene_func( "p7_fxanim_cp_infection_church_explode_01_bundle", &scene_callback_tank_warp, "done" );
	
	scene::add_scene_func( "p7_fxanim_cp_infection_church_explode_02_bundle", &scene_callback_tank_start_2, "play" );
	scene::add_scene_func( "p7_fxanim_cp_infection_church_tank_02_bundle", &scene_callback_tank_end_2, "done" );
}

function cathedral_scene_setup()
{	
	scene::add_scene_func( "cin_inf_11_06_fold_vign_hell", &scene_sarah_appears_in_cathedral, "init" );
	scene::add_scene_func( "cin_inf_11_06_fold_vign_hell", &scene_sarah_disappears_in_cathedral, "play" );
	
	exploder::exploder( "cathedral_altar_fires" );
}

function wait_enemy_cleared()
{
	a_ai = GetAITeamArray( "axis" );
	
	while( a_ai.size > 0 )
	{
		wait 0.1;
		a_ai = GetAITeamArray( "axis" );
	}	
}	

function cathedral_spawn_ai()
{	
	spawn_manager::enable( "sm_cathedral_upper" );
	spawn_manager::enable( "sm_cathedral_lower" );
	trigger::wait_or_timeout(20, "cathedral_intro_reverse" );
	
	if ( level.players.size <= 2 )
	{ 
		spawn_manager::set_global_active_count( 21 );
	}
	if ( level.players.size >= 3 )
	{ 
		spawn_manager::set_global_active_count( 31 );
	}
}	

function battle_in_cathedral()
{
	//setup reverse ai intro in cathedral
	infection_util::setup_reverse_time_arrivals( "cathedral_reverse_anim" );
	level thread cathedral_spawn_ai();
	
	level flag::wait_till( "cathedral_quad_tank_destroyed" );
	
	spawn_manager::kill( "sm_cathedral_upper" );
	spawn_manager::kill( "sm_cathedral_lower" );
	
	util::wait_network_frame();  // delay killing guys off a bit
	
	level thread all_remaining_enemies_die_off();
}

function all_remaining_enemies_die_off()
{
	a_ai = GetAITeamArray( "axis" );
	for ( i = 0; i < a_ai.size; i++ )
	{
		if( isAlive( a_ai[i] ))
		{
			a_ai[i] Kill();
			wait 0.1;
		}
	}	
}

function sarah_appears()
{
	level scene::init( "cin_inf_11_06_fold_vign_hell" );
}

function wait_for_players_to_approach_sarah()
{	
	trig = GetEnt( "cathedral_sarah_at_altar", "targetname" );
	trig triggerenable( true );
	trig waittill( "trigger", who );
	
	level flag::set( "sarah_distance_objective" );
	objectives::complete( "cp_standard_breadcrumb" );
			
	//everyone goes into setlowready
	array::thread_all(level.players, &infection_util::player_enter_cinematic );
	
	level thread scene::play( "cin_inf_12_01_underwater_1st_fall_loop" );	
}

function sarah_vignette_in_cathedral()
{
	level scene::play( "cin_inf_11_06_fold_vign_hell" );	
}

function scene_sarah_appears_in_cathedral( a_ents )
{	
	if( !level flag::get( "sarah_distance_objective" ) )
	{	
		objectives::set( "cp_standard_breadcrumb" , a_ents[ "sarah" ] );
	}
		
	a_ents[ "sarah" ] thread infection_util::actor_camo( 0 );
}

function scene_sarah_disappears_in_cathedral( a_ents )
{	
	wait 40;
	a_ents[ "sarah" ] thread infection_util::actor_camo( 1 );
}


// Self is a player
function play_floor_breaks_rumble( n_loops, n_wait )
{
	self endon( "death" );
	
	for( i = 0; i < n_loops; i++ )
	{
		 self PlayRumbleOnEntity( "cp_infection_floor_break" );
		 
		 wait n_wait;
	}
}

function floor_breaks_away()
{	
	wait 0.5;  // delay this slightly so players can see Theia disappear
	
	infection_util::gather_players_inside_volume( "cathedral_floor_breaks_volume" );
	
	wait 0.1; // wait a little bit so the players are teleport to the locations
	
	foreach ( player in level.players )
	{	
		player thread play_floor_breaks_rumble( 6, 1 );
		Earthquake( 0.22, 7, player.origin, 150 );
	}
	
	level thread scene::play( "p7_fxanim_cp_infection_cathedral_floor_bundle" );  // fxanim	

	wait 2.0; // let the player experiences the shake and rumble for a big before start the floor break anim
	
	foreach ( player in level.players )
	{
		player.scene_def = "cin_inf_12_01_underwater_1st_fall_01";
		player thread scene::play( player.scene_def, player );	
	}
	array::wait_till( level.players, "scene_done" );

	exploder::exploder_stop( "cathedral_altar_fires" );
		
	level thread skipto::objective_completed( "cathedral" );			
}

function church_doors_close()
{
	level clientfield::set( "light_church_ext_window", 0 );
	
	a_doors = GetEntArray( "church_door", "targetname" );
	Assert( a_doors.size, "church_doors_close: couldn't find church door entities!" );
	
	const DOOR_CLOSE_TIME = 1.5;
	const DOOR_CLOSE_ACCEL_TIME = 0.25;
	const DOOR_CLOSE_DECEL_TIME = 0.25;
	
	a_temp_ents = [];
	
	foreach ( m_door in a_doors )
	{
		Assert( IsDefined( m_door.script_int ), "church_doors_close: found door at " + m_door.origin + " without script_int KVP! This is used to rotate doors to the correct angle" );
		Assert( IsDefined( m_door.target ), "church_doors_close: found door at " + m_door.origin + " without struct target!" );
		
		// TEMP: door model origin isn't at hinge, so spawn in a script origin to rotate at the correct location 
		s_rotate = struct::get( m_door.target, "targetname" );
		e_temp = Spawn( "script_origin", s_rotate.origin );
		
		m_door LinkTo( e_temp );
		
		e_temp RotateYaw( m_door.script_int, DOOR_CLOSE_TIME, DOOR_CLOSE_ACCEL_TIME, DOOR_CLOSE_DECEL_TIME );
		e_temp playsound ("evt_church_doors_close");
		
		if ( !isdefined( a_temp_ents ) ) a_temp_ents = []; else if ( !IsArray( a_temp_ents ) ) a_temp_ents = array( a_temp_ents ); a_temp_ents[a_temp_ents.size]=e_temp;;
	}
	
	wait DOOR_CLOSE_TIME;
	
	// rumble when door closed.
	foreach ( player in level.players )
	{
		player playrumbleonentity( "damage_heavy" );
	}
	
	// get rid of our temp ents
	foreach ( e_temp in a_temp_ents )
	{
		e_temp Delete();
	}
}

function warp_players_inside_cathedral()
{
	// important: info_volumes don't properly store angles, so rotation throws off translated local coordinates. 
	// use a reference object that does instead. 	
	s_start = struct::get( "church_in_foy", "targetname" );
	Assert( IsDefined( s_start ), "warp_players_inside_cathedral: s_start is missing!" );
	
	s_end = struct::get( "church_inside_cathedral", "targetname" );
	Assert( IsDefined( s_end ), "warp_players_inside_cathedral: s_end is missing!" );
	
	m_start = util::spawn_model( "tag_origin", s_start.origin, s_start.angles );
	m_end = util::spawn_model( "tag_origin", s_end.origin, s_end.angles );
	
	// the players are warped between two identical buildings. There is a prefabbed reference brush inside both,
	// and we use those to map the player position from one to the other
	foreach ( player in level.players )
	{
		v_local = m_start WorldToLocalCoords( player.origin );
		v_warp = m_end LocalToWorldCoords( v_local );
		
		v_angles = CombineAngles( ( m_end.angles - m_start.angles ), player GetPlayerAngles() );
		player SetOrigin( v_warp );
		player SetPlayerAngles( v_angles );
	}
	
	// get rid of temp ents
	m_start Delete();
	m_end Delete();
	
	// The objective of CHURCH HAS TO COMPLETE HERE as soon as we warp the player to a different location so that
	// respawn player will be respawned inside the cathedral, not the church.
	skipto::objective_completed( "church" );
}

function scene_callback_tank_start_1( a_ents )
{		
	level thread scene::play( "p7_fxanim_cp_infection_church_tank_01_bundle" );
	
	level waittill ( "tank_push" ); // coming from p7_fxanim_cp_infection_church_tank_01_bundle
	
	array::spread_all( level.players, &tank_push, a_ents[0] );
	
	wait 0.75; // wait for the tank comes through before removing sarah.
	
	ai_objective_sarah = util::get_hero( "sarah" );
	
	ai_objective_sarah thread infection_util::actor_camo( 1 );
	
	wait 1;	// Hide Sarah once camo is on.
	
	ai_objective_sarah Ghost();  
}

function tank_push( mdl_tank )
{
	// self = player
	const n_tank_force = 1200;
	
	// Figure out the player's facing, toward or away from the tank.
	v_dir_tank = mdl_tank.origin - self.origin;
	v_dir_tank = VectorNormalize( v_dir_tank );
	v_forward = AnglesToForward( self.angles );
	
	n_dp = VectorDot( v_dir_tank, v_forward );
	
	if ( n_dp >= 0 )
	{
		n_tank_force_dir = -1;
	}
	else
	{
		n_tank_force_dir = 1;
	}
	
	v_dir = AnglesToForward( self.angles );	
	n_strength = n_tank_force_dir * n_tank_force;
	self SetVelocity( v_dir * n_strength );
}

function scene_callback_tank_start_2( a_ents )
{
	a_ents[ 0 ] SetForceNoCull();  // a_ents[ 0 ] is the fxanim house
	
	level thread scene::play( "p7_fxanim_cp_infection_church_tank_02_bundle" );
	
	level waittill( "fxanim_church_explosion_starts" );
	
	a_ents[ 0 ] NotSolid();  // a_ents[ 0 ] is the fxanim house, which has a collmap
	
	level waittill( "light_church_int_cath_all_off" );
	
	level clientfield::set( "light_church_int_cath_all", 0 );
}

function scene_callback_tank_end_2( a_ents )
{
	vh_tank = a_ents[ "tiger_tank_church" ];
	
	spawn_quad_tank( vh_tank );
	
	wait 0.05;
	
	vh_tank Delete();  // TODO: get fx for this
}

function scene_callback_tank_warp( a_ents )
{
	level flag::set( "church_warp_ready" );
}

function scene_callback_tank_test( a_ents )
{
	level flag::set( "church_warp_ready" );
}

function tiger_tank_drives_into_church()
{
	level scene::play( "p7_fxanim_cp_infection_church_explode_01_bundle" );
	
	level thread infection_util::delete_all_ai();  // church door is closed and sarah is gone, so delete all AI here
	
	/# iprintlnbold( "tiger tank breaks through wall" ); #/
	
	level flag::wait_till( "church_warp_ready" );	
		
	warp_players_inside_cathedral();
	level clientfield::set( "light_church_int_all", 0 );
	
	level scene::stop( "cin_inf_11_04_fold_vign_walk_end" );
	
	level scene::play( "p7_fxanim_cp_infection_church_explode_02_bundle" );
}

function ai_accuracy()
{
	self.script_accuracy = 0.70;
}



