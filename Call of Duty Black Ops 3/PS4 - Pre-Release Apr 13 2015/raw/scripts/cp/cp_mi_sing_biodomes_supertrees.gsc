/*
 * Created by ScriptDevelop.
 * User: jalexander
 * Date: 8/15/2014
 * Time: 2:44 PM
 * 
 * To change this template use Tools | Options | Coding | Edit Standard Headers.
 */

#using scripts\codescripts\struct;

#using scripts\cp\_dialog;
#using scripts\cp\_objectives;
#using scripts\cp\_skipto;
#using scripts\cp\_spawn_manager;
#using scripts\cp\_util;

#using scripts\shared\ai_shared;
#using scripts\shared\animation_shared;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\colors_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_ai_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\vehicles\_hunter;

#using scripts\cp\cp_mi_sing_biodomes_util;
#using scripts\cp\cp_mi_sing_biodomes_swamp;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       









	
#precache( "triggerstring", "CP_MI_SING_BIODOMES_ZIPLINE_USE" );
#precache( "string", "CP_MI_SING_BIODOMES_HUNTER_LOCK_ON" );
#precache( "lui_menu", "HunterPatrolSightingMenu" );
#precache( "lui_menu_data", "hunter_patrol_sight_title" );
#precache( "lui_menu_data", "hunter_patrol_sight_timer" );
#precache( "lui_menu_data", "hunter_patrol_sight_timer_max" );
#precache( "lui_menu_data", "hunter_patrol_sight_alpha" );

function main()
{
	level thread ziplines_supertrees_setup();
	level thread playerdive_supertrees_setup();
	level thread zipline_gates_setup();
	
	//allows guys spawned from spawn managers to use ziplines as an entrance as well.
	spawner::add_spawn_function_group( "zipline_guys", "script_noteworthy", &zipline_AI);
	
	//used to make sure the special Hendricks zipline scenes stop if enemy is killed while ziplining
	spawner::add_spawn_function_group( "zipline_scene_guys", "script_noteworthy", &zipline_scene_AI);
	
	//tracks when player 1 has finished ziplining to last tree
	a_reached_finaltree_triggers = GetEntArray( "reached_finaltree_triggers", "script_noteworthy" );
	array::thread_all( a_reached_finaltree_triggers, &player_reached_finaltree );
	
	a_bridge_cam_enter = GetEntArray( "bridge_trigger_enter", "script_noteworthy" );
	array::thread_all( a_bridge_cam_enter, &bridge_cam_enter );
	
	//used to determine what kind of zipline weapon to switch to in the zipline_player() thread
	level.W_PISTOL_STANDARD = GetWeapon( "pistol_standard" );
	level.W_PISTOL_FULLAUTO = GetWeapon( "pistol_fullauto" );
	level.W_PISTOL_BURST = GetWeapon( "pistol_burst" );
	
	level.W_PISTOL_STANDARD_ZIPLINE = GetWeapon( "pistol_standard_zipline" );
	level.W_PISTOL_FULLAUTO_ZIPLINE = GetWeapon( "pistol_fullauto_zipline" );
	level.W_PISTOL_BURST_ZIPLINE = GetWeapon( "pistol_burst_zipline" );
	level.W_NOWEAPON_ZIPLINE = GetWeapon( "noweapon_zipline" );
	
	setup_scenes();
}

function setup_scenes()
{
	scene::add_scene_func( "cin_bio_13_03_treefight_1st_zipline", &zipline_player_elevator_scene_play, "play" );
	scene::add_scene_func( "cin_bio_14_01_treejump_vign_elevator_shaft_hendricks", &zipline_hendricks_elevator_scene_done, "done" );
}

//Descend (Slide down the dome connected to the supertrees)
function objective_descend_init( str_objective, b_starting )
{
	cp_mi_sing_biodomes_util::objective_message( "objective_descend_init" );
	cp_mi_sing_biodomes_util::init_hendricks( str_objective );
	skipto::teleport_ai( "objective_supertrees" ); //TODO get Hendricks into place for now, replace with slide at some point
	
	if ( b_starting )
	{		
		
	}
	
	//trigger will track when individual players hit it to disable invulnerability
	trig_slide_landing = GetEnt( "trig_objective_descend_complete", "targetname" );
	level thread util::single_thread( trig_slide_landing, &player_slide_start );
	
	//start some enemies that are firing at the player from the supertree that's about to explode
	a_supertree_explode_enemies = spawner::simple_spawn( "sp_supertrees_tree1_explode", &enemy_explode_spawns );
	
	trigger::wait_till( "trig_objective_descend_complete" );
	skipto::objective_completed( "objective_descend" );
}

//self is trigger
function player_slide_start()
{
	self endon( "death" );
	
	while ( true )
	{
		self trigger::wait_till();
		player = self.who;
		
		//player only needs to hit this trigger once
		self SetInvisibleToPlayer( player );
		player thread player_slide_finished();
	}
}

//self is a player
function player_slide_finished()
{
	self EnableInvulnerability();
	
	wait 2; //allow some time to pass for player to land after hitting trigger

	self DisableInvulnerability();
}


function objective_descend_done( str_objective, b_starting, b_direct, player )
{
	cp_mi_sing_biodomes_util::objective_message( "objective_descend_done" );
}

//spawn function for guys I want to immediately be dead or lying on the ground in agony
function ai_dying_poses()
{	
	self ai::gun_remove();
	self ai::set_ignoreme( true );
	
	n_animation = RandomIntRange( 1, 4 );
	
	//script bundles are placed at specific locations in radiant
	switch( n_animation )
	{
		case 1:
			level thread scene::play( "cin_gen_m_wall_rightleg_wounded", self );
			break;			
		case 2:
			level thread scene::play( "cin_gen_m_floor_head_wounded", self );	
			break;
		case 3:
			level thread scene::play( "cin_gen_m_floor_stomach_wounded", self );
			break;
		default:
			self Kill();
			break;
	}
	
	//prevents writhing guys from popping up after shooting them
	self waittill( "death" );
	
	self StartRagdoll( true );
}

//used for guys that are waiting around by the supertrees for supertree to explode
function enemy_explode_spawns()
{
	self endon( "death" );
	
	self.goalradius = 4;
	self.goalheight = 4;
	
	level waittill( "supertree_explode" );
	
	n_animation = RandomIntRange( 1, 4 );
	
	wait RandomFloatRange( 0.25, 0.75 ); //keep everyone from reacting at the same time
	
	switch( n_animation )
	{
		case 1:
			self thread scene::play( "cin_gen_xplode_death_1", self );
			break;			
		case 2:
			self thread scene::play( "cin_gen_xplode_death_2", self );	
			break;
		case 3:
			self thread scene::play( "cin_gen_xplode_death_3", self );
			break;	
		default:
			break;
	}
}

//Super Trees
function objective_supertrees_init( str_objective, b_starting )
{
	cp_mi_sing_biodomes_util::objective_message( "objective_supertrees_init" );
	
	if ( b_starting )
	{
		cp_mi_sing_biodomes_util::init_hendricks( str_objective );
		
		//start some enemies that are firing at the player from the supertree that's about to explode
		a_supertree_explode_enemies = spawner::simple_spawn( "sp_supertrees_tree1_explode", &enemy_explode_spawns );
	}
	
	level thread restaurant_zipline_icon();
	level thread zipline_icon();
	level thread hendricks_final_tree();
	level thread hunter_finaltree_dive_trigger();
	level thread hunter_supertree_boat_fire();
	level.ai_hendricks thread hendricks_zipline_takedown();
	
	//make sure Hendricks uses color chains throughout supertrees, not hendricks_follow_player()
	level.ai_hendricks notify( "stop_following" );
	level.ai_hendricks ClearForcedGoal();
	level.ai_hendricks.goalradius = 200;
	level.ai_hendricks.goalheight = 80;
	level.ai_hendricks colors::enable();

	level thread supertrees_hunter( false );
	
	//leads player to the last supertree, up to the top, and then to the airboat
	//thread objectives::breadcrumb( "cp_level_biodomes_escape", "trig_supertrees_breadcrumb" );
	level thread supertrees_objectives();
	
	level thread vo_supertrees_intro();
	
	//wait for player to get to top of last supertree
	trigger::wait_till( "trig_supertrees_breadcrumb3" );
	
	level flag::set( "player_reached_top_finaltree" );
	
	//do a special objective waypoint just for the jump off the tree
	s_supertree_jump = struct::get( "s_waypoint_supertree_jump" );
	Assert( isdefined ( s_supertree_jump ), "Struct needed for the supertree jump objective" );
	
	level thread objectives::set( "cp_level_biodomes_jump_from_supertree", s_supertree_jump );
	
	level thread cp_mi_sing_biodomes_swamp::airboat_spawn();
	
	trigger::wait_till( "trig_objective_supertrees_done" );
	
	//kill any spawn managed enemies who may be remaining in the supertrees, use same function from biodomes markets
	cp_mi_sing_biodomes_util::kill_previous_spawns( "sm_supertrees_tree1_enemy1" );
	cp_mi_sing_biodomes_util::kill_previous_spawns( "sm_supertrees_tree1_enemy2" );
	cp_mi_sing_biodomes_util::kill_previous_spawns( "sm_supertrees_tree3_enemy1" );
	cp_mi_sing_biodomes_util::kill_previous_spawns( "sm_supertrees_tree4_enemy1" );
	cp_mi_sing_biodomes_util::kill_previous_spawns( "sm_supertrees_tree5_enemy1" );
	cp_mi_sing_biodomes_util::kill_previous_spawns( "sm_supertrees_finaltree_enemy1" );
	
	level skipto::objective_completed( "objective_supertrees" );
}

function vo_supertrees_intro()
{
	level dialog::player_say( "plyr_plan_c_0", 2 ); //Plan C?
	
	level.ai_hendricks dialog::say( "hend_plan_c_into_comms_0", 1 ); //"Plan C. (into comms) Kane - Exfil too hot. Proceeding tertiary protocol echo three!"

	level dialog::remote( "kane_confirmed_proceed_t_0", 1 ); //Confirmed. Proceed to marker. 54i dock. You’re going to have to Hijack one of their boats.
	
	level.ai_hendricks dialog::say ( "hend_copy_that_let_s_get_0" ); //Can't wait. (to us) Let’s get the hell outta here!!!
}

function supertrees_objectives()
{
	objectives::set( "cp_level_biodomes_escape" );
	objectives::set( "cp_level_biodomes_supertrees_waypoint", struct::get( "supertrees_waypoint_1" ) );
	
	trigger::wait_till( "trigger_supertrees_waypoint" );
	
	objectives::complete( "cp_level_biodomes_supertrees_waypoint", struct::get( "supertrees_waypoint_1" ) );
	
	objectives::set( "cp_level_biodomes_supertrees_waypoint", struct::get( "supertrees_waypoint_2" ) );
	
	trigger::wait_till( "trig_supertrees_finaltree_hunter" );
	
	objectives::complete( "cp_level_biodomes_supertrees_waypoint", struct::get( "supertrees_waypoint_2" ) );
}

function vo_hendricks_supertrees()
{			
	//"Immortals - hunt down and destroy the invaders who have defiled our lands and our people. (beat) Bleed them. Make them suffer. Lead them to their deaths."
	level dialog::remote( "xiul_immortals_hunt_dow_0", 4 );
	
	level.ai_hendricks dialog::say( "hend_shit_i_d_kinda_ho_0" ); //Shit... I was hoping she’d never wake up.
	
	a_dialogue_lines = [];
	a_dialogue_lines[0] = "hend_move_0"; //MOVE!!
	a_dialogue_lines[1] = "hend_on_me_let_s_move_0"; //On me, let’s move!
	
	level.ai_hendricks dialog::say( cp_mi_sing_biodomes_util::vo_pick_random_line( a_dialogue_lines ), 4 );
	
	level flag::wait_till( "any_player_reached_bottom_finaltree" );
	
	level.ai_hendricks dialog::say( "hend_we_re_pinned_down_in_0", 3 ); //We’re pinned down in here, Kane!
	
	level thread dialog::remote( "kane_use_the_elevator_sha_0" ); //Use the elevator shaft.
	
	trigger::wait_till( "trig_supertrees_breadcrumb3" );
		
	level.ai_hendricks dialog::say( "hend_dammit_we_re_sittin_0" );//"Dammit! We’re sitting ducks! (beat) We’re gonna have to jump!"
	
	level.ai_hendricks dialog::say( "hend_come_on_go_go_go_0" ); //Come on! GO, GO, GO!!
}

//self is a trigger that encompasses the bridge
function bridge_cam_enter()
{
	while ( isdefined( self ) )
	{
		self trigger::wait_till();
		
		//spin off thread for individual players that touch the trigger
		self.who thread player_camera_sway( self );
	}
}

//self is player that has stepped on the bridge
function player_camera_sway( t_bridge )
{	
	self endon( "death" );
	
	//make sure same player doesn't keep activating the trigger
	t_bridge SetInvisibleToPlayer( self );
	
	while ( self IsTouching( t_bridge ) )
	{
		//TODO sway player camera slightly here and/or sway the actual bridge model
		n_sway_time = RandomFloatRange( 1.0, 3.0 );
		
		//wait a few seconds before swaying it again
		wait n_sway_time;
	}
	
	//TODO player is no longer in trigger, set camera defaults if needed
	
	//player has left trigger, let them be able to activate it again
	t_bridge SetVisibleToPlayer( self );
}

//self is hendricks
function hendricks_zipline_takedown()
{
	trigger::wait_till( "trig_supertrees_hunter_flyby1" );
	
	//Hendricks gets into position for zipline scene
	//TODO add code that can pick between scenes if we need to implement one for other zipline on tree
	level thread scene::init( "cin_bio_13_02_treefight_vign_ziplinekill" );
	self thread dialog::say( "Hunter's coming. Get inside the tree! Wait for it to pass." );
	
	trigger::wait_till( "trig_supertrees_tree2_enemy2_zipline" );
	
	level scene::play( "cin_bio_13_02_treefight_vign_ziplinekill" );
	
	level flag::set( "hendricks_played_supertree_takedown" );
}

//self is the ziplining AI that spawns during the special Hendricks hero moments
function zipline_scene_AI()
{
	self waittill( "death" );
	
	if ( level scene::is_playing( "cin_bio_13_02_treefight_vign_ziplinekill" ) )
	{
		level scene::stop( "cin_bio_13_02_treefight_vign_ziplinekill" );
	}
}

//self is the hunter, fires turret back and forth across the windows in this area
function hunter_restaurant_sweep( target, time_to_fire, delay_after_fire )
{
	self endon( "supertrees_done" );
	level endon( "reached_dock" );
	self endon( "death" );
	
	m_hunter_target = util::spawn_model( "tag_origin", target.origin, target.angles );
	
	while ( true )
	{
		self SetTurretTargetEnt( m_hunter_target );	
		self thread vehicle_ai::fire_for_time( time_to_fire );
		
		wait time_to_fire + delay_after_fire;
	}
}

//runs at the beginning of this section, waits for player to get into the final tree before continuing with special hunter scene at top
function hunter_finaltree_dive_trigger()
{
	trigger::wait_till( "trig_supertrees_finaltree_hunter" );
	
	hunter_finaltree_dive_logic( false );
}

//this is now used in both the dive skipto, and in normal gameplay progression
function hunter_finaltree_dive_logic( starting_from_dive_skipTo )
{
	//spawn another hunter for convenience to setup scene at the top
	veh_new_hunter = spawner::simple_spawn_single( "sp_hunter_supertrees" );
	
	veh_new_hunter vehicle_ai::start_scripted();
	
	s_hunter_finaltree_hover1 = struct::get( "s_hunter_finaltree_hover1" , "targetname" );
	veh_new_hunter SetVehGoalPos( s_hunter_finaltree_hover1.origin, true );

	veh_new_hunter waittill( "goal" );
	
	//make sure a player has actually reached the top before continuing to fire (isn't needed if using skipto)
	if ( !starting_from_dive_skipto )
	{
		level flag::wait_till( "player_reached_top_finaltree" );
	}
	
	//start moving on spline in front of player's view
	hunter_finaltree_strafe_path = GetVehicleNode( "hunter_finaltree_strafe_path", "targetname" );
	veh_new_hunter drivepath( hunter_finaltree_strafe_path );
	
	//target for hunter to fire at inside
	hunter_turret_target2 = struct::get( "hunter_target_finaltree_2", "targetname" );	
	veh_new_hunter thread hunter_restaurant_sweep( hunter_turret_target2, 12, 10 );
	
	//bring in enough flying vehicles to scare off player so that they don't hang around at the top
	spawn_manager::enable( "sm_finaltree_horde_wasps" );
	spawn_manager::enable( "sm_finaltree_horde_hunters" );
	
	//when someone lands in the swamp, set hunter back to normal
	trigger::wait_till( "trigger_dive_done" );
	
	//don't need this anymore
	spawn_manager::kill( "sm_finaltree_horde_wasps" );
	spawn_manager::kill( "sm_finaltree_horde_hunters" );
	
	//don't want the hunter shooting down at us
	a_hunters = spawn_manager::get_ai( "sm_finaltree_horde_hunters" );
	array::thread_all( a_hunters, &ai::set_ignoreall, true );

	if ( IsAlive( veh_new_hunter ) )
	{
		veh_new_hunter ai::set_ignoreall( true );
	}
}

//this function handles the hunter that stalks you throughout the supertrees (leftover from the descend event)
function supertrees_hunter( starting_from_dive_skipTo )
{
	if ( starting_from_dive_skipTo )
	{
		hunter_finaltree_dive_logic( true );
	}
	else
	{	
		//otherwise, we're starting from the beginning of the supertrees
		
		//make sure old hunter spawn manager is still enabled
		spawn_manager::enable( "sm_supertrees_hunter" );
		wait 1;
		a_oldhunter = spawner::get_ai_group_ai( "supertrees_hunter_aigroup" );
		
		if ( isdefined( a_oldhunter ) )
		{
			a_oldhunter[0] notify( "hunter_stop_firing" ); //make sure hunter stops doing the scripted firing stuff from the top of the dome
			a_oldhunter[0] endon( "death" );
			
			//don't want Hendricks to fire at hunter
			a_oldhunter[0] ai::set_ignoreme( true );
			
			a_oldhunter[0] vehicle_ai::start_scripted();
			
			a_oldhunter[0] flag::init( "hunter_sees_player" );
			
			//enable vtol for hunter to fire at
			//TODO replace with pre-existing vtol from dome scene when added, have vtol fight back and/or fly around
			veh_vtol = spawner::simple_spawn_single( "vtol_supertrees_crash" );
			veh_vtol.allowdeath = false;
			
			trigger::wait_till( "trig_supertree_crash_start" );
			
			//hunter flies towards vtol...
			node_start = GetVehicleNode( "hunter_supertrees_path_start", "targetname" );
			a_oldhunter[0] thread vehicle::get_on_and_go_path( node_start );
			wait 0.5; //slight delay to allow time for it to get on path before setting speed
			a_oldhunter[0] SetSpeed( 50, 15, 5 );
			a_oldhunter[0] hunter::disable_turrets();
			
			a_oldhunter[0] util::waittill_notify_or_timeout( "hunter_fire_path0_1", 10 );
			
			//...and fires 3 rockets at it
			for ( i = 0; i < 3; i++ )
			{
				a_oldhunter[0] hunter::hunter_fire_one_missile( 0, veh_vtol );
				wait 0.5;
			}
			
			//vtol gets damaged and moves towards supertree TODO have vtol be able to take real damage and check that instead
			wait 2; //allow time for missile fire
			fx::play( "explosion_dome", veh_vtol.origin);
			PlaySoundAtPosition( "wpn_rocket_explode" ,  veh_vtol.origin );
			
			//destinations for vtol crash
			vtol_supertrees_crash1 = struct::get( "vtol_supertrees_crash1", "targetname" );
			vtol_supertrees_crash2 = struct::get( "vtol_supertrees_crash2", "targetname" );
			
			//get vtol moving towards tree
			m_vtol_mover = util::spawn_model( "tag_origin", veh_vtol.origin, veh_vtol.angles );
			veh_vtol LinkTo( m_vtol_mover, "tag_origin" );
			m_vtol_mover MoveTo( vtol_supertrees_crash1.origin, 3 );
			m_vtol_mover RotateVelocity( (50, 10, 100), 3 );
			m_vtol_mover waittill( "movedone");
			
			//tree gets knocked down as vtol hits it
			fx::play( "explosion_dome", vtol_supertrees_crash1.origin );
			PlaySoundAtPosition( "wpn_rocket_explode" ,  vtol_supertrees_crash1.origin );
			level clientfield::set( "supertree_fall_play", 1 );
			thread tree_fall_earthquake();
			
			//vtol careens off the tree
			m_vtol_mover MoveTo( vtol_supertrees_crash2.origin, 2 );
			m_vtol_mover RotateVelocity( (-50, 10, 100), 3 );
			m_vtol_mover waittill( "movedone");
			
			//get rid of vtol
			fx::play( "explosion_dome", veh_vtol.origin);
			PlaySoundAtPosition( "wpn_rocket_explode" ,  veh_vtol.origin );
			veh_vtol Unlink();
			m_vtol_mover Delete();
			veh_vtol Delete();
			
			//Once player gets halfway through first tree, have hunter start its tree patrol
			trigger::wait_till( "trig_supertrees_hunter_flyby1" );
			
			a_oldhunter[0] thread hunter_supertree_patrol( "info_volume_hunter_patrol_tree1" );
			
			//thread for each player to determine if the hunter can see them
			foreach( player in level.players )
			{
				player thread track_player_near_hunter( a_oldhunter[0] );
			}
		}		
	}
}

//when a player reaches the inside of the last tree, clean up any HUD stuff
function hunter_patrol_HUD_cleanup()
{	
	//wait for a player to get inside of last tree
	trigger::wait_till( "trig_supertrees_finaltree_hunter" );
	
	level thread cleanup_hunter_HUD();
}

//self is hunter
function hunter_patrol_HUD_cleanup_death()
{
	self waittill( "death" );
	
	level thread cleanup_hunter_HUD();
}

function cleanup_hunter_HUD()
{
	//no longer need to track the player through supertrees, end track_player_near_hunter() thread and close HUD on each player
	foreach( player in level.players )
	{	
		if ( isdefined( player GetLUIMenu( "HunterPatrolSightingMenu" ) ) )
		{
			player CloseLUIMenu( player GetLUIMenu( "HunterPatrolSightingMenu" ) );
		}
		
		player notify ( "hunter_sees_player" );
	}
}

//self is the hunter
function hunter_supertree_patrol( str_first_goal_volume )
{	
	self endon( "death" );
	self endon( "supertree_boat_fire" );
	level endon( "boats_departed" );
	
	a_goal_volumes = GetEntArray( "hunter_supertree_patrol_volumes", "script_noteworthy" );
	
	//have hunter fly directly to the first goal volume to kick things off
	e_current_goal = GetEnt( str_first_goal_volume, "targetname" );
	Assert( isdefined( e_current_goal ), "Goal entity for hunter in the supertrees is undefined" );
	
	self vehicle_ai::start_scripted();
	self SetVehGoalPos( e_current_goal.origin, true, true );
	self waittill( "goal" );
	
	while ( true )
	{		
		//only have it go to regular combat mode at that tree if it's already seen one of the players
		//and we're not already at the end of the supertrees
		if ( self flag::get( "hunter_sees_player" ) && !level flag::get( "player_reached_top_finaltree" ) )
		{
			self vehicle_ai::stop_scripted( "combat" );
			self SetGoal( e_current_goal, true );
		}
		else
		{
			//TODO have hunter do something fancy when it reaches a tree and still hasn't seen the player
		}
		
		//keep it at that tree for a random time window
		wait RandomIntRange( 3, 6 );
		
		//if hunter has seen a player, have him fly towards goal that's closest to his current attacker/enemy
		//otherwise, have him fly towards next goal linked in radiant
		if ( self flag::get( "hunter_sees_player" ) && !level flag::get( "player_reached_top_finaltree" ) )
		{
			if ( isdefined( self.attacker ) )
			{
				//if being attacked, go closer to that player. Should allow for "pulling" the hunter in co-op from different trees
				e_closest_enemy = self.attacker;
			}
			else if ( isdefined( self.enemy ) )
			{
				//if not being attacked, but hunter still has a valid enemy, count them as the closest
				e_closest_enemy = self.enemy;
			}
			else
			{
				//if no one's attacking or there's no current enemy for whatever reason, just go for first player as a fallback
				e_closest_enemy = level.players[0];
			}
			
			e_current_goal = array::get_closest( e_closest_enemy.origin, a_goal_volumes );
			Assert( isdefined( e_current_goal ), "Goal entity for hunter in the supertrees is undefined" );
		}
		else
		{
			e_current_goal = GetEnt( e_current_goal.target, "targetname" );
			Assert( isdefined( e_current_goal ), "Goal entity for hunter in the supertrees is undefined" );
		}
		
		//have hunter fly towards new goal
		self ClearLookAtEnt();			
		self vehicle_ai::start_scripted();
		self SetVehGoalPos( e_current_goal.origin, true, true );
		self waittill( "goal" );
	}
	
}

//have hunter in the supertrees start the "final tree on fire" scene
function hunter_supertree_boat_fire()
{
	trigger::wait_till ( "trig_supertrees_hunter_flyby2" );
	
	//only spawn a new hunter if the initial hunter was killed
	if ( spawner::get_ai_group_sentient_count( "supertrees_hunter_aigroup" ) == 0 )
	{
		veh_hunter_boat_fire = spawner::simple_spawn_single( "sp_hunter_supertree_boat_fire" );
		veh_hunter_boat_fire flag::init( "hunter_sees_player" ); //preserve flag from other hunter on the new one
	}
	else
	{
		a_oldhunters = spawner::get_ai_group_ai( "supertrees_hunter_aigroup" );
		veh_hunter_boat_fire = a_oldhunters[0];
	}
	
	veh_hunter_boat_fire endon( "death" );
	
	//end the current iteration of hunter_supertree_patrol if needed
	veh_hunter_boat_fire notify( "supertree_boat_fire" );
	
	level thread final_supertree_fire();
	
	//have hunter fly into position over the boat near the last tree	
	e_current_goal = GetEnt( "info_volume_supertrees_hunter_patrol_end", "targetname" );
	veh_hunter_boat_fire vehicle_ai::start_scripted();
	veh_hunter_boat_fire SetVehGoalPos( e_current_goal.origin, true, true );
	
	veh_hunter_boat_fire waittill( "goal" );
	
	wait 2; //allow a bit of time for the hunter to train its sights before firing
	
	a_boat_fire_targets = struct::get_array( "s_hunter_supertree_boat_fire", "targetname" );
	Assert( a_boat_fire_targets.size > 0, "Add more script_structs named s_hunter_supertree_boat_fire for hunter to fire upon" );
	
	//make sure hunter is facing the right direction
	m_hunter_target = util::spawn_model( "tag_origin", a_boat_fire_targets[0].origin, a_boat_fire_targets[0].angles );
	veh_hunter_boat_fire SetLookAtEnt( m_hunter_target );
	veh_hunter_boat_fire SetTurretTargetEnt( m_hunter_target );
	
	wait 3; //give a bit of time to settle into place before firing
	
	//fire a volley of missiles at random points around the bottom of the tree near the boat
	for ( i = 0; i < 10; i++ )
	{
		//find a random point in the target array
		n_index = RandomIntRange( 0, a_boat_fire_targets.size );
		e_target = a_boat_fire_targets[n_index];
		
		veh_hunter_boat_fire hunter::hunter_fire_one_missile( 0, e_target.origin );
		wait 1;
	}
	
	//TODO set boat and bottom of tree on fire
	fx::play( "explosion_dome", a_boat_fire_targets[0].origin);
	
	wait 5; //give a bit of time for players to compose themselves before hunter goes back on the attack
	
	veh_hunter_boat_fire ClearLookAtEnt();
	veh_hunter_boat_fire ClearTurretTarget();
	m_hunter_target Delete();
	
	//put hunter on the patrol and attack regardless of whether it's seen the player previously
	veh_hunter_boat_fire flag::set( "hunter_sees_player" );
	veh_hunter_boat_fire thread hunter_supertree_patrol( "info_volume_hunter_patrol_tree3" );
}

function dev_supertrees_fire_init( str_objective, b_starting )
{
	cp_mi_sing_biodomes_util::init_hendricks( str_objective );
	level thread cp_mi_sing_biodomes_swamp::airboat_spawn();
	level thread hendricks_final_tree();
	level flag::set( "hendricks_played_supertree_takedown" );
	
	level flag::wait_till( "first_player_spawned" );
	
	wait 3; //allow time for player to drop in before kicking everything off
	
	level thread final_supertree_fire();
}

function final_supertree_fire()
{
	//start bottom of tree on fire
	exploder::exploder( "fx_supertree_boat_exp" );
	exploder::exploder( "fx_supertree_boat_fire" );
	
	//wait for player to actually be on the final tree
	level flag::wait_till( "any_player_reached_bottom_finaltree" );
	
	//play next round of effects covering the middle of the last tree
	exploder::exploder( "fx_supertree_ext_fire" );
	exploder::exploder( "fx_supertree_battery_exp" );
	
	s_hunter_supertree_boat_fire = struct::get_array( "s_hunter_supertree_boat_fire" );
	Earthquake( 0.5, 1, s_hunter_supertree_boat_fire[0].origin, 3000 );
	
	//flag is currently set on final zipline trigger_use's in radiant
	level flag::wait_till( "player_ziplines_up_last_tree" );
	
	//start hendricks at the same time
	level thread scene::play( "cin_bio_14_01_treejump_vign_elevator_shaft_hendricks" );
	level scene::play( "cin_bio_13_03_treefight_1st_zipline" );
	
	level util::teleport_players_igc( "dive_start_igc" );
}

function zipline_player_elevator_scene_play( a_ents )
{
	level waittill( "elevator_fire_plays" );
	
	//offset the effect so that it lags behind the player as they move up
	player = a_ents[ "player 1" ];
	const n_fire_time = 4;
	player fx::play( "explosion_zipline_up", player.origin + (0, 0, -150), undefined, n_fire_time, true );
	
	wait n_fire_time; //after the attached fire goes out, play an effect that fills up the tunnel
	
	e_fire_elevator = GetEnt( "fx_fire_elevator", "targetname" );
	
	if ( isdefined( e_fire_elevator ) )
	{
		//TODO using same effect as before for now. Will probably be replaced with an exploder in the future
		e_fire_elevator fx::play( "explosion_zipline_up", e_fire_elevator.origin, undefined );
	}
}

//get hendricks into position for dive after he gets up the elevator
function zipline_hendricks_elevator_scene_done( a_ents )
{
	level thread scene::init( "cin_bio_14_01_treejump_vign_dive" );
	
	level thread start_hendricks_dive();
}

//self is the player being tracked
function track_player_near_hunter( e_hunter )
{
	self endon( "hunter_sees_player" );
	self endon( "disconnect" );
	e_hunter endon( "death" );
	
	n_timer = 0;
	n_alpha = 1;
	
	//timer and red light are dynamic elements in menu that responds to hunter when it's in the vicinity of the player
//	if ( !isdefined( self GetLUIMenu( "HunterPatrolSightingMenu" ) ) )
//	{
//		self.hunter_patrol_sighting_menu = self OpenLUIMenu( "HunterPatrolSightingMenu", true );
//		self SetLUIMenuData( self.hunter_patrol_sighting_menu, "hunter_patrol_sight_title", &"CP_MI_SING_BIODOMES_HUNTER_LOCK_ON" );
//		self SetLUIMenuData( self.hunter_patrol_sighting_menu, "hunter_patrol_sight_timer", Int( n_timer ) );
//		self SetLUIMenuData( self.hunter_patrol_sighting_menu, "hunter_patrol_sight_timer_max", Int( N_HUNTER_SIGHT_TIMER_MAX ) );
//		self SetLUIMenuData( self.hunter_patrol_sighting_menu, "hunter_patrol_sight_alpha", n_alpha );
//	}
//	
//	wait 2; //allow some time for default LUI animation to finish
	
	alpha = 0;
	
	//will get rid of HUD once a player reaches the last tree or the initial hunter dies
	level thread hunter_patrol_HUD_cleanup();
	e_hunter thread hunter_patrol_HUD_cleanup_death();
	
	while ( true )
	{
		//if hunter can see any player and is within a certain distance, add to timer
		distance_sq = Distance2DSquared( self.origin, e_hunter.origin );
		
		if ( e_hunter VehCanSee( self ) && !self laststand::player_is_in_laststand() && distance_sq <= 2500 * 2500 )
		{
			//iPrintLnBold( self.playerName+" hide from hunter!" );
			n_timer += 0.05;
			
			//make sure timer doesn't go above max, which also keeps alpha from going above 1
			if ( n_timer > 6 )
			{
				n_timer = 6;
			}
			
			n_alpha  = n_timer / 6;
			
//			self SetLUIMenuData( self.hunter_patrol_sighting_menu, "hunter_patrol_sight_timer", Int( n_timer ) );			
//			self SetLUIMenuData( self.hunter_patrol_sighting_menu, "hunter_patrol_sight_alpha", n_alpha );
//			self SetLUIMenuData( self.hunter_patrol_sighting_menu, "hunter_patrol_sight_timer_max", Int( N_HUNTER_SIGHT_TIMER_MAX ) );
		}
		//if hunter can't see player anymore, or is too far away, decrement timer
		else if ( !e_hunter VehCanSee( self ) || distance_sq > 2500 * 2500 )
		{
			n_timer -= 0.05;
			
			//make sure timer never goes below 0, which also keeps alpha from going below 0
			if ( n_timer < 0 )
			{
				n_timer = 0;
			}
			
			n_alpha  = n_timer / 6;
			
//			self SetLUIMenuData( self.hunter_patrol_sighting_menu, "hunter_patrol_sight_timer", Int( n_timer ) );
//			self SetLUIMenuData( self.hunter_patrol_sighting_menu, "hunter_patrol_sight_alpha", n_alpha );
//			self SetLUIMenuData( self.hunter_patrol_sighting_menu, "hunter_patrol_sight_timer_max", Int( N_HUNTER_SIGHT_TIMER_MAX ) );
		}
		
		//if hunter has seen any player for a given amount of time, or if the player has shot the hunter enough, or if it was set to be seen in hunter_supertree_boat_fire()
		if ( n_timer >= 6 || ( e_hunter.health < e_hunter.healthdefault * 0.9 ) || e_hunter flag::get( "hunter_sees_player" ) )
		{
			n_timer = 0;
			e_hunter flag::set( "hunter_sees_player" ); //let's hunter_supertree_patrol know to go into combat when it reaches its destination
			
			//let hendricks shoot at the hunter again
			e_hunter ai::set_ignoreme( false );
			
			level.ai_hendricks thread dialog::say( "Crap, the hunter sees us! Avoid it by going inside the trees if you can!" );
			
			//close down hud for all players now
			level thread cleanup_hunter_HUD();
		}
		
		wait 0.05;
	}
}

//TODO tie this in more closely with fxanim using notetracks
function tree_fall_earthquake()
{
	//point on tree
	s_tree = struct::get( "hunter_target_tree1_1", "targetname" );
	Assert( isdefined( s_tree ), "Collapsing tree location is undefined" );
	
	//start off with long, light rumble for a few seconds as it cracks
	Earthquake( 0.1, 6, s_tree.origin, 6000 );
	fx::play( "explosion_dome", s_tree.origin);
	level notify( "supertree_explode" );
	
	//spawn some guys that get put into special animations
	a_wounded_ai = spawner::simple_spawn( "sp_supertree_tree1_wounded", &ai_dying_poses );
	
	level thread ragdoll_spewer( "sp_supertrees_treecrash_ragdolls1", 2, (80, 15, 90 ), 0, 0.25 );
	level thread ragdoll_spewer( "sp_supertrees_treecrash_ragdolls2", 2, (80, 15, 100 ), 0, 0.25 );
	wait 4;
	
	//increase to long, medium rumble as it falls for a few more seconds
	Earthquake( 0.3, 6, s_tree.origin, 6000 );
	wait 5;
	
	//short heavy rumble as it lands
	Earthquake( 0.45, 2, s_tree.origin, 6000);
	
	//if player hasn't already run ahead to the trigger to spawn wasps, bring them in at this point
	if ( !spawn_manager::is_enabled( "sm_supertrees_wasp1" ) )
	{
		spawn_manager::enable( "sm_supertrees_wasp1" );
	}
	
	wait 3;
	
	level thread vo_hendricks_supertrees();
}

//takes a spawner and throws out a number of ragdolls from it with the given force
function ragdoll_spewer( str_spawner, num_ragdolls, v_velocity, min_delay = 0, max_delay = 0.1 )
{
	//launch some ragdolls
	for ( i = 0; i < num_ragdolls; i++ )
	{
		ai = spawner::simple_spawn_single( str_spawner );
		ai StartRagdoll();
		
		//slightly varies forces between each ragdoll
		perturbance_x = RandomIntRange( -5, 5 );
		perturbance_y = RandomIntRange( -5, 5 );
		perturbance_z = RandomIntRange( -5, 5 );
		
		v_velocity += ( perturbance_x, perturbance_y, perturbance_z );
		
		ai LaunchRagdoll( v_velocity );
		ai Kill();
		
		wait RandomFloatRange( min_delay, max_delay ); //slight delay between spews
	}
}

//self is the hunter AI vehicle
//structs should be named with a numerical index at the end, like hunter_tree1_1, hunter_tree1_2, etc.
//pass in the base name, and _index will be added automatically
function hunter_missile_volley( str_tree_struct_prefix, start_index, end_index, min_delay = 1, max_delay = 1 )
{
	//loop through from start to end index
	for( i = start_index; i <= end_index; i++ )
	{
		s_missile_dest = struct::get( str_tree_struct_prefix+"_"+i, "targetname" );
		Assert( isdefined ( s_missile_dest ), "There is no struct with the targetname"+str_tree_struct_prefix+"_"+i );
		
		self hunter::hunter_fire_one_missile( 0, s_missile_dest );
		wait_time = RandomFloatRange( min_delay, max_delay+0.01 );
		
		wait wait_time;
	} 
}

//trigger function to let us know when player 1 has reached the final tree. Flag is used
//to keep Hendricks from continuously trying to follow on the ziplines after this point, since he would now be ziplining
//to final tree on his own
function player_reached_finaltree()
{	
	while ( isdefined( self ) && self IsTriggerEnabled() )
	{
		self trigger::wait_till();
		
		level flag::set( "any_player_reached_bottom_finaltree" );
		
		//only want to set the flag and deactivate trigger if it's the first player (who Hendricks follows on ziplines)
		if ( self.who == level.players[0] )
		{
			level flag::set( "player_reached_bottom_finaltree" );
			
			//don't need any of the triggers anymore once any of them have been hit
			a_reached_finaltree_triggers = GetEntArray( "reached_finaltree_triggers", "script_noteworthy" );
			foreach( trigger in a_reached_finaltree_triggers )
			{
				trigger TriggerEnable( false );
			}
		}
	}
}

//use this to have him stop fighting enemies and get him to the top of the tree asap when trigger is hit
//once this is in motion, Hendricks should be able to dive from tree on his own regardless of whether player speedruns through it or not
function hendricks_final_tree()
{
	//wait for hendricks to reach there
	trigger::wait_till( "trig_supertrees_hendricks_finaltree" );
	
	level flag::set( "hendricks_reached_finaltree" );
		
	//and also make sure hendricks is off the zipline before receiving his next commands
	level.ai_hendricks flag::wait_till_clear( "hendricks_on_zipline" );
	
	level.ai_hendricks colors::disable();
	level.ai_hendricks ClearForcedGoal();
	
	//have hendricks zipline up the final tree on his own
	s_hendricks_final_zipline = struct::get( "s_hendricks_final_zipline", "targetname" );
	
	level.ai_hendricks thread zipline_Hendricks( s_hendricks_final_zipline, true );
}

//put into thread so it can be used in normal progression or after skipTo
function start_hendricks_dive()
{
	//set in Radiant
	level flag::wait_till( "start_hendricks_dive" );
	
	level thread scene::play( "cin_bio_14_01_treejump_vign_dive" );
}

function objective_supertrees_done( str_objective, b_starting, b_direct, player )
{
	cp_mi_sing_biodomes_util::objective_message( "objective_supertrees_done" );
}

//Dive Off the Supertrees
function objective_dive_init( str_objective, b_starting )
{
	cp_mi_sing_biodomes_util::objective_message( "objective_dive_init" );
	
	if ( b_starting )
	{		
		cp_mi_sing_biodomes_util::init_hendricks( str_objective );
		
		level flag::set( "player_reached_bottom_finaltree" );
		level flag::set( "player_reached_top_finaltree" );
		level flag::set( "any_player_reached_bottom_finaltree" );
		level flag::set( "hendricks_played_supertree_takedown" );

		//make sure hunter is hanging around as well at beginning of skipTo
		level thread supertrees_hunter( true );
	
		objectives::set( "cp_level_biodomes_escape" );
		objectives::set( "cp_level_biodomes_jump_from_supertree", struct::get( "s_waypoint_supertree_jump" ) );
		
		level thread cp_mi_sing_biodomes_swamp::airboat_spawn();
		
		exploder::exploder( "fx_supertree_boat_exp" );
		exploder::exploder( "fx_supertree_ext_fire" );
		
		level thread start_hendricks_dive();
	}
	
	//no longer need the hunter to respawn
	spawn_manager::kill( "sm_supertrees_hunter" );
	
	//clear out commands initiated at the base of the tree
	level.ai_hendricks notify( "supertrees_done" );
	level notify( "supertrees_done" );
	level.ai_hendricks ai::set_behavior_attribute( "sprint", false );
	level.ai_hendricks ai::set_ignoreall( false );
	
	trigger::wait_till( "trig_objective_supertrees_done" );
	
	level thread cp_mi_sing_biodomes_swamp::dock_guard();
	level thread cp_mi_sing_biodomes_swamp::hunter_fuel_truck();

	trigger::wait_till( "trigger_dive_done" );
	
	level skipto::objective_completed( "objective_dive" );
}

function objective_dive_done( str_objective, b_starting, b_direct, player )
{
	cp_mi_sing_biodomes_util::objective_message( "objective_dive_done" );
	
	objectives::complete( "cp_level_biodomes_jump_from_supertree" );
}




//============================================================
// SUPERTREES ZIPLINES AND ZIPLINE GATES

//allows gate to track its own state and be opened/closed appropriately
class cZiplineGate
{
	var m_a_gate;							//an array with two elements in it, left side of gate (index 0), and right side of gate (index 1)
	var m_str_targetname;
	var m_str_target;
	var m_n_gate_open_time;				//how long it takes to animate open the gate
	var m_n_gate_close_time;				//how long it takes to animate close the gate
	
	var m_n_default_origin_left;	
	var m_n_default_origin_right;
	
	//used for RotateTo calls below so that left and right gate pieces always know their "start" position and don't go past it
	var m_n_closed_angles_left;
	var m_n_closed_angles_right;
	
	//used for RotateTo calls below so that left and right gate pieces always known their "end" position and don't go past it
	var m_n_opened_angles_left;
	var m_n_opened_angles_right;
	
	constructor()
	{
		//basic default values. Most work should be done in the init function though
		m_a_gate = GetEntArray( "gate_tree_1a", "targetname" );
		m_str_targetname = m_a_gate[0].targetname;
		m_str_target = m_a_gate[0].target;
		
		m_n_gate_open_time = 0.25;
		m_n_gate_close_time = 0.25;
		
		m_n_default_origin_left = m_a_gate[0].origin;
		m_n_default_origin_right = m_a_gate[1].origin;
		
		m_n_opened_angles_left = m_a_gate[0].angles;
		m_n_opened_angles_right = m_a_gate[1].angles;
		
		m_n_closed_angles_left = m_a_gate[0].angles;
		m_n_closed_angles_right = m_a_gate[1].angles;
	}
	
	destructor()
	{
		
	}
	
	function init( str_gate )
	{
		m_a_gate = GetEntArray( str_gate, "targetname" );
		m_str_targetname = str_gate;
		m_str_target = m_a_gate[0].target;
		
		//index 0 is gate_left, index 1 is gate_right
		m_n_default_origin_left = m_a_gate[0].origin;
		m_n_default_origin_right = m_a_gate[1].origin;
		
		m_n_closed_angles_left = m_a_gate[0].angles;
		m_n_closed_angles_right = m_a_gate[1].angles;
		
		//restaurant gate_01 and 02 are at an odd angle, so they require slightly different rotations
		if ( m_str_targetname == "restaurant_gate_01" )
		{
			m_n_opened_angles_left = m_a_gate[0].angles + ( m_a_gate[0].angles[0] + 14, m_a_gate[0].angles[1] + -90, m_a_gate[0].angles[2] + 0 );
			m_n_opened_angles_right = m_a_gate[1].angles + ( m_a_gate[1].angles[0] + -2, m_a_gate[1].angles[1] + 90, m_a_gate[1].angles[2] + -18 );
		}
		else if ( m_str_targetname == "restaurant_gate_02" )
		{
			m_n_opened_angles_left = m_a_gate[0].angles + ( m_a_gate[0].angles[0] + 2, m_a_gate[0].angles[1] + -90, m_a_gate[0].angles[2] + -4 );
			m_n_opened_angles_right = m_a_gate[1].angles + ( m_a_gate[1].angles[0] + -8, m_a_gate[1].angles[1] + 90, m_a_gate[1].angles[2] + -5 );
		}
		else
		{
			//all other gates would just need their yaw adjusted
			m_n_opened_angles_left = m_a_gate[0].angles + ( m_a_gate[0].angles[0], m_a_gate[0].angles[1] + -90, m_a_gate[0].angles[2] );
			m_n_opened_angles_right = m_a_gate[1].angles + ( m_a_gate[1].angles[0], m_a_gate[1].angles[1] + 90, m_a_gate[1].angles[2] );
		}
		
		//due to the separate gate_left and gate_right script_noteworthy inside each of the 12 zipline gate prefabs,
		//it would normally end up adding 24 separate class objects to the array. We only need the "full" gate (denoted by targetname in Radiant) for the object,
		//so this makes sure the same gate isn't added twice to the array.
		b_already_in_array = false;	
		foreach ( o_gate_temp in level.a_zipline_gates )
		{
			if ( [[o_gate_temp]]->get_targetname_str() == [[self]]->get_targetname_str() )
			{
				b_already_in_array = true;
				break;
			}
		}
		
		if ( !b_already_in_array )
		{
			array::add( level.a_zipline_gates, self );
		}
	}
	
	function open_gates()
	{

		m_a_gate[0] RotateTo( m_n_opened_angles_left, m_n_gate_open_time );
		m_a_gate[1] RotateTo( m_n_opened_angles_right, m_n_gate_open_time );
		
		PlaySoundAtPosition( "evt_zipline_gate_open", m_n_default_origin_left );
		
		wait m_n_gate_open_time;
	}
	
	function close_gates()
	{		
		m_a_gate[0] RotateTo( m_n_closed_angles_left, m_n_gate_close_time );
		m_a_gate[1] RotateTo( m_n_closed_angles_right, m_n_gate_close_time );

		PlaySoundAtPosition( "evt_zipline_gate_close", m_n_default_origin_left );
		
		wait m_n_gate_close_time;
	}
	
	function get_targetname_str()
	{
		return m_str_targetname;
	}
	
	function get_target_str()
	{
		return m_str_target;
	}
}

//runs through all the zipline_gates in the level and creates classes based off each one
function zipline_gates_setup()
{	
	level.a_zipline_gates = [];
	
	//using script_parameters instead since script_noteworthy is already used for the left and right sides of the gates inside the gate prefabs
	a_supertrees_gates = GetEntArray( "zipline_gates", "script_parameters" );
	array::thread_all( a_supertrees_gates, &create_zipline_gate_objects );
}

//self is each set of gate prefabs in the supertrees, targetname is unique for each gate
function create_zipline_gate_objects()
{
	o_zipline_gate = new cZiplineGate();
	[[o_zipline_gate]]->init( self.targetname );
}

//opens the appropriate zipline gate prefabs whenever a player triggers a zipline
//self is the player or AI that's ziplining, e_start is either the trigger (when player uses it) or a script_struct (when AI uses it)
function zipline_gates( e_start, m_mover )
{	
	self endon ( "death" );

	//search through all the gates and get the gate object of that matches e_start's script_parameters
	if ( isdefined ( e_start.script_parameters ) )
	{
		foreach ( o_gate_temp in level.a_zipline_gates )
		{
			if ( [[o_gate_temp]]->get_targetname_str() == e_start.script_parameters )
			{
				o_gate_start = o_gate_temp;
				break;
			}
		}
	
		//find the class associated with the target gate
		foreach ( o_gate_temp in level.a_zipline_gates )
		{
			if ( [[o_gate_temp]]->get_target_str() == [[o_gate_start]]->get_targetname_str() )
				{
					o_gate_dest = o_gate_temp;
					break;
				}
		}
	}
	
	//open and close the gates
	if ( isdefined( o_gate_start ) && isdefined( o_gate_dest ) )
	{
		thread [[o_gate_start]]->open_gates();
		thread [[o_gate_dest]]->open_gates();
		
		m_mover waittill ( "movedone" );
		
		thread [[o_gate_start]]->close_gates();
		thread [[o_gate_dest]]->close_gates();
	}
}

//find all the interact triggers for players and setup zipline interactions
function ziplines_supertrees_setup()
{	
	//Do all my setup for the zipline related triggers in the level. This is called from main
	a_zipline_triggers = GetEntArray( "zipline_trigger", "script_noteworthy" );
	array::thread_all( a_zipline_triggers, &zipline_player_trigger );
}

//player zipline logic
function zipline_player_trigger()
{
	//"self" refers to every trigger with the "zipline_trigger" script_noteworthy tag in the function above
	//each trigger should have a script_struct as its target for the start point, and then that start point should have a script_struct end point
	//as its target
	
	self SetHintString( &"CP_MI_SING_BIODOMES_ZIPLINE_USE" );
	self SetCursorHint( "HINT_NOICON" );

	//Get the start point of zipline
	s_start = struct::Get( self.target, "targetname");
	Assert( isdefined ( s_start ), "Trigger at position " + self.origin + " must target a struct to define the zipline start position" );

	//Get the end point of zipline
	s_end = struct::Get( s_start.target, "targetname");
	Assert( isdefined ( s_end ), "Zipline start struct at position " + s_start.origin + " must target a struct to define the zipline ending position" );
	
	while ( isdefined ( self ) )
	{
		//Wait for player to activate initial trigger
		self trigger::wait_till();
		
		//get the player who just used this trigger
		self.who thread zipline_player( self, s_start, s_end );
	}
}

//self is a player
//this function switches to a special zipline weapon (derived from a pistol) for the player ziplining
//and also spawns a clone of the player who is using a special 3rd person zipline animation
//the clone is hidden from the ziplining player, and can be seen by other players
//the actual zipliner is hidden from other players
function zipline_player( trigger, s_start, s_end )
{
	self endon( "death" );
	
	//setup mover for player traveling on the zipline
	e_playermover = util::spawn_model( "tag_origin", self.origin, s_start.angles );
	self PlayerLinkToDelta( e_playermover, "tag_origin", 1, 20, 20, 15, 60 );
	
	n_dist = Distance( s_start.origin, s_end.origin );
	n_time = n_dist / 600;
	
	self EnableInvulnerability();
	self DisableWeaponCycling();
	self DisableOffhandWeapons();
	self AllowCrouch( false );
	self AllowProne( false );
	
	e_playermover playsoundtoplayer( "evt_zipline_attach", self );
	
	//spawn player clone to use for 3rd person animations
	m_player_fake = util::spawn_player_clone( self );
	
	//TODO try placing zipline tool attachment directly into .gdt animations
	m_zipline_tool = util::spawn_model( "wpn_t7_zipline_trolley_prop", m_player_fake GetTagOrigin( "tag_weapon_left" ), m_player_fake GetTagAngles( "tag_weapon_left" ) );
	m_zipline_tool LinkTo( m_player_fake, "tag_weapon_left" );
	
	//save off current weapon that gets restored when zipline is finished, and also switch to appropriate zipline weapon
	w_current = self GetCurrentWeapon();
	w_zipline_pistol = self get_player_zipline_weapon();
	m_weapon_fake = util::spawn_model( w_zipline_pistol.worldmodel, m_player_fake GetTagOrigin( "tag_weapon_right" ), m_player_fake GetTagAngles( "tag_weapon_right" ) );
	m_weapon_fake LinkTo( m_player_fake, "tag_weapon_right" );
	
	b_has_sidearm = true;
	if ( w_zipline_pistol === level.W_NOWEAPON_ZIPLINE )
	{
		b_has_sidearm = false;
	}
	
	//clone should be invisible to player using zipline, but still visible to everyone else.	
	m_player_fake SetInvisibleToPlayer( self );
	m_zipline_tool SetInvisibleToPlayer( self );
	m_weapon_fake SetInvisibleToPlayer( self );
	
	//only let ziplining player see their real entity
	self SetInvisibleToAll();
	self SetVisibleToPlayer( self );
	
	//initial animation to the attach point
	if ( b_has_sidearm )
	{
		m_player_fake thread animation::play( "pb_pistol_zipline_enter", e_playermover, "tag_origin" );
	}
	else
	{
		m_player_fake thread animation::play( "pb_zipline_enter", e_playermover, "tag_origin" );
	}
	
	e_playermover MoveTo( s_start.origin, 0.25 );
	e_playermover waittill( "movedone" );
	
	//open the gates
	self thread zipline_gates( trigger, e_playermover );
	
	//only have Hendricks follow the first player on the zipline if player hasn't already reached the final tree
	if ( self == level.players[0] && !level flag::get( "player_reached_bottom_finaltree" ) )
	{
		level.ai_hendricks thread zipline_Hendricks( s_start );
	}
	
	//move to end of zipline
	self playsoundtoplayer ("evt_zipline_move", self );
	if ( b_has_sidearm )
	{
		m_player_fake thread animation::play( "pb_pistol_zipline_loop", e_playermover, "tag_origin" );
	}
	else
	{
		m_player_fake thread animation::play( "pb_zipline_loop", e_playermover, "tag_origin" );
	}
	
	e_playermover MoveTo( s_end.origin, n_time );
	e_playermover waittill ( "movedone" );

	//find a good spot to land when finished
	v_on_navmesh = GetClosestPointOnNavMesh( e_playermover.origin, 72, 48 );
	if ( isdefined ( v_on_navmesh ) )
	{
		if ( b_has_sidearm )
		{
			m_player_fake thread animation::play( "pb_pistol_zipline_exit", e_playermover, "tag_origin" );
		}
		else
		{
			m_player_fake thread animation::play( "pb_zipline_exit", e_playermover, "tag_origin" );
		}
		e_playermover MoveTo( v_on_navmesh, 0.5 );
		e_playermover waittill( "movedone" );
	}
	
	self Unlink();
	
	//update my current tree info
	self.str_current_tree = s_end.script_label;
	
	//get rid of zipline weapon and switch back to the old weapon once player dismounts
	self EnableWeaponCycling();
	self EnableOffhandWeapons();
	self AllowCrouch( true );
	self AllowProne( true );
	
	self TakeWeapon( w_zipline_pistol );
	self SwitchToWeaponImmediate( w_current );
	
	//player can take damage again
	self DisableInvulnerability();
	
	//get rid of fake zipline stuff
	e_playermover Delete();
	m_weapon_fake Delete();
	m_zipline_tool Delete();
	m_player_fake Delete();
	
	self SetVisibleToAll();
}

//self is a player
function get_player_zipline_weapon()
{
		//these are defined in main, commented here for reference		
//		level.W_PISTOL_STANDARD = GetWeapon( "pistol_standard" );
//		level.W_PISTOL_FULLAUTO = GetWeapon( "pistol_fullauto" );
//		level.W_PISTOL_BURST = GetWeapon( "pistol_burst" );
//		
//		level.W_PISTOL_STANDARD_ZIPLINE = GetWeapon( "pistol_standard_zipline" );
//		level.W_PISTOL_FULLAUTO_ZIPLINE = GetWeapon( "pistol_fullauto_zipline" );
//		level.W_PISTOL_BURST_ZIPLINE = GetWeapon( "pistol_burst_zipline" );
//		level.W_NOWEAPON_ZIPLINE = GetWeapon( "noweapon_zipline" );
		
		//switch to the special zipline weapon if player does have any type of pistol, otherwise switch to empty hands	
		if ( self HasWeapon( level.W_PISTOL_STANDARD ) )
		{
			w_zipline_pistol = level.W_PISTOL_STANDARD_ZIPLINE;
		}
		else if ( self HasWeapon( level.W_PISTOL_FULLAUTO ) )
		{
			w_zipline_pistol = level.W_PISTOL_FULLAUTO_ZIPLINE;
		}
		else if ( self HasWeapon( level.W_PISTOL_BURST ) )
		{
			w_zipline_pistol = level.W_PISTOL_BURST_ZIPLINE;
		}
		else
		{
			w_zipline_pistol = level.W_NOWEAPON_ZIPLINE;
		}
		
		self GiveWeapon( w_zipline_pistol );
		self SwitchToWeaponImmediate( w_zipline_pistol );
		
		return w_zipline_pistol;
}

//============================================================
//zipline logic for Hendricks
//self is level.ai_hendricks
function zipline_Hendricks( struct_start, b_final_zipline = false )
{
	//if it's not the final hendricks zipline to top of tree, kill any active hendricks zipline threads
	if ( !b_final_zipline )
	{
		self notify( "hendricks_zipline_stop" );
	}
	
	self notify( "stop_following" );
	
	if ( b_final_zipline )
	{
		//get in place for final supertree scenes
		nd_hendricks = GetNode( "hendricks_elevator_goal", "targetname" );
		level.ai_hendricks SetGoal( nd_hendricks );
	}
	else
	{
		//make sure Hendricks has played the zipline takedown before trying to follow the player on the zipline
		level flag::wait_till( "hendricks_played_supertree_takedown" );
			
		//update Hendricks' target info to use the struct that the player started at so that it works with existing zipline_AI()
		self.target = struct_start.targetname;
		self thread zipline_AI();
	}
}

//self is an enemy AI or level.ai_hendricks
//code is similar to player zipline logic
function zipline_AI()
{	
	//find the start point for the enemy to zipline from
	s_start = struct::Get( self.target, "targetname");
	Assert( isdefined ( s_start ), "Enemy at position " + self.origin + " must target a struct to define the zipline start position" );

	//Get the end point of zipline
	s_end = struct::Get( s_start.target, "targetname");
	Assert( isdefined ( s_end ), "Zipline start struct at position " + s_start.origin + " must target a struct to define the zipline ending position" );
	
	if ( self == level.ai_hendricks )
	{
		self endon( "hendricks_zipline_stop" );
		
		//want Hendricks to get there asap
		self colors::disable();
		self flag::set( "hendricks_on_zipline" );
	}
	
	self endon( "death" );
	self endon( "stop_zipline_AI" );
	
	self ai::set_behavior_attribute( "sprint", true );
	self ai::set_ignoreall( true );
	
	//since start point for zipline animation might be a bit elevated, find a valid closest point on the navmesh
	v_on_navmesh = GetClosestPointOnNavMesh( s_start.origin, 100, 12 );
	if ( isdefined ( v_on_navmesh ) )
	{
		self thread ai::force_goal( v_on_navmesh, 12, true );
		
		//setup mover for AI traveling on the zipline, raise up start point from the nav mesh a little bit
		e_AImover = util::spawn_model( "tag_origin", v_on_navmesh + ( 0, 0, 36 ), s_start.angles );
	}
	else
	{
		//fallback in case v_on_navmesh doesn't get defined for some reason
		self thread ai::force_goal( s_start.origin, 12, true );
		
		//setup mover for AI traveling on the zipline
		e_AImover = util::spawn_model( "tag_origin", s_start.origin, s_start.angles );
	}
	
	self util::waittill_notify_or_timeout( "goal", 15 );
	
	//update my current tree info to the tree I'm headed to
	self.str_current_tree = s_end.script_label;
	
	//can start shooting again
	self ai::set_ignoreall( false );
	
	self.b_using_zipline = true;
	
	n_dist = Distance( s_start.origin, s_end.origin );
	
	//have Hendricks move at the player's speed on the zipline, and the enemy AI at a slower speed
	if ( self == level.ai_hendricks )
	{
		n_time = n_dist / 600;
	}
	else
	{
		n_time = n_dist / 350;
		
		//also let AI be shot down more easily
		self.health = 5;
	}
	
	//HACK make sure mover starts from mid-air close to the zipline for the zipline loop after the initial mount
	//will try to standardize heights for animation to remove need for this, if possible
	e_AImover scene::play( "cin_gen_traversal_zipline_enemy01_attach", self );
	e_AImover.origin = s_start.origin;
	e_AImover thread scene::play( "cin_gen_traversal_zipline_enemy01_idle", self );
	
	//Begin moving towards end point
	e_AImover MoveTo( s_end.origin, n_time );
	
	//so that AI can open the gates as well
	self thread zipline_gates( s_start, e_AImover );
	
	e_AImover util::waittill_notify_or_timeout( "movedone", 8 );
	
	//detach them at the end	
	//HACK simulate the dismount animating downward. Would be better if we standardize dismount heights instead for animation
	v_on_navmesh = GetClosestPointOnNavMesh( e_AImover.origin, 72, 36 );
	if ( isdefined ( v_on_navmesh ) )
	{
		e_AImover MoveTo( v_on_navmesh, 0.5 );
	}
	
	e_AImover scene::play( "cin_gen_traversal_zipline_enemy01_dismount", self );
	self.b_using_zipline = false;
	self notify( "dismount_zipline" );
	self Unlink();
	e_AImover Delete();
	
	//adjusted goal height lets guys better find nodes on their own with the multi-level supertrees
	self ClearForcedGoal();
	self ai::set_behavior_attribute( "sprint", false );
	
	//set Hendricks back to normal
	if ( self == level.ai_hendricks)
	{
		self ai::set_ignoreall( false );
		self flag::clear( "hendricks_on_zipline" );
		self colors::enable();
	}
	
	//make sure only enemies update their goal radius/height and do zipline pursuits
	if ( self != level.ai_hendricks )
	{
		self.goalradius = 2000;
		self.goalheight = 200;
		self.health = self.maxhealth;
		self ai::set_ignoreall( false );
		
		wait RandomIntRange( 8, 15 ); //don't want to immediately pursue players across ziplines
		
		self thread zipline_pursuer();
	}
}

//self is an AI
//used to find a new tree to zipline to if they can't reach the player
//TODO have any AI in the supertrees be able to do this, instead of just the original zipliners
function zipline_pursuer()
{
	self endon( "death" );
	level endon( "supertrees_done" );
	
	b_player_reachable = false;
	
	while( true )
	{
		wait RandomIntRange( 3, 7 ); //AI checks every few seconds if they need to change trees
		
		//check to see if I'm on the same tree as any active player
		foreach( player in level.players )
		{
			if ( player.str_current_tree === self.str_current_tree )
			{
				b_player_reachable = true;
				break;
			}
			else
			{
				b_player_reachable = false;
			}		
		}
		
		//if no player is reachable, start search for nearest zipline point
		if( !b_player_reachable )
		{
			//find closest player
			e_closest_player = array::get_closest( self.origin, level.players );
			
			//find zipline path to the tree they're on
			//find nearest zipline to use, blocks until it actually finishes the zipline, or a notify ends it
			self find_zipline_path( self.str_current_tree, e_closest_player.str_current_tree );
		}
	}
}

//self is an AI
//script_label kvp on each zipline script_struct: tree1, tree2, tree3, tree4, tree5, treefinal
//tree1 connects to tree2 and tree3
//tree2 connects to tree1 and tree4
//tree3 connects to tree1, tree4, and tree5
//tree4 connects to tree2, tree3, and treefinal
//tree5 connects to tree3, and treefinal
function find_zipline_path( str_current_tree, str_dest_tree )
{
	self endon( "death" );
	self endon( "stop_zipline_AI" );
	
	//get all the zipline start locations of the tree I'm currently on
	a_zipline_current_tree = struct::get_array( str_current_tree, "script_label" );
	
	//if there are no valid zipline nodes on the tree I'm on for some reason, bail out
	if( !a_zipline_current_tree.size )
	{
		return;
	}
	
	//given my current location, and my destination, what's the tree I need to get to, to reach the player?
	//this accounts for "intermediate" trees that I may need to go to, in order to eventually reach the player
	if( str_current_tree === "tree1" )
	{
		switch( str_dest_tree )
		{
			case "tree2":
				//directly from tree1 to tree2
				self find_immediate_zipline( a_zipline_current_tree, "tree2" );
				break;
			case "tree3":
				//directly from tree1 to tree3
				self find_immediate_zipline( a_zipline_current_tree, "tree3" );
				break;
			case "tree4":
				//go from tree1 to tree2, eventually leads to tree4
				self find_immediate_zipline( a_zipline_current_tree, "tree2" );
				break;
			case "tree5":
				//go from tree1 to tree3, eventually leads to tree5
				self find_immediate_zipline( a_zipline_current_tree, "tree3" );
				break;
			case "treefinal":
				//go from tree1 to tree3, eventually leads to tree4 or tree5, eventually leads to treefinal
				self find_immediate_zipline( a_zipline_current_tree, "tree3" );
				break;
			default:
				break;
				
		}
	}
	else if( str_current_tree === "tree2" )
	{
		switch( str_dest_tree )
		{
			case "tree1":
				//go directly to tree1
				self find_immediate_zipline( a_zipline_current_tree, "tree1" );
				break;
			case "tree3":
				//go back to tree1 first, which will eventually lead to tree3
				self find_immediate_zipline( a_zipline_current_tree, "tree1" );
				break;
			case "tree4":
				//can just run up the bridge to tree 4
				nd_dest = GetNode( "nd_tree4_center", "targetname" );
				self SetGoal( nd_dest, true );
				self waittill( "goal" );
				self.str_current_tree = "tree4";
				self thread zipline_pursuer();
				break;
			case "tree5":
				//run to tree 4, which will eventually lead to tree5
				nd_dest = GetNode( "nd_tree4_center", "targetname" );
				self SetGoal( nd_dest, true );
				self waittill( "goal" );
				self.str_current_tree = "tree4";
				self thread zipline_pursuer();
				break;
			case "treefinal":
				//run to tree 4, which will eventually lead to treefinal
				nd_dest = GetNode( "nd_tree4_center", "targetname" );
				self SetGoal( nd_dest, true );
				self waittill( "goal" );
				self.str_current_tree = "tree4";
				break;
			default:
				break;
				
		}
	}
	else if( str_current_tree === "tree3" )
	{
		switch( str_dest_tree )
		{
			case "tree1":
				//go directly to tree1
				self find_immediate_zipline( a_zipline_current_tree, "tree1" );
				break;
			case "tree2":
				//go to tree1, which will eventually lead to tree2
				self find_immediate_zipline( a_zipline_current_tree, "tree1" );
				break;
			case "tree4":
				//go directly to tree4
				self find_immediate_zipline( a_zipline_current_tree, "tree4" );
				break;
			case "tree5":
				//go directly to tree5
				self find_immediate_zipline( a_zipline_current_tree, "tree5" );
				break;
			case "treefinal":
				//go to tree5, which will eventually lead to treefinal
				self find_immediate_zipline( a_zipline_current_tree, "tree5" );
				break;
			default:
				break;
				
		}
	}
	else if( str_current_tree === "tree4" )
	{
		switch( str_dest_tree )
		{
			case "tree1":
				//go to tree3, which eventually leads to tree1
				self find_immediate_zipline( a_zipline_current_tree, "tree5" );
				break;
			case "tree2":
				//can just run down the bridge to tree2, then restart my zipline search from there
				nd_dest = GetNode( "nd_tree2_center", "targetname" );
				self SetGoal( nd_dest, true );
				self waittill( "goal" );
				self.str_current_tree = "tree2";
				self thread zipline_pursuer();
				break;
			case "tree3":
				//go directly to tree3
				self find_immediate_zipline( a_zipline_current_tree, "tree3" );
				break;
			case "tree5":
				//go to tree3, which eventually leads to tree5
				self find_immediate_zipline( a_zipline_current_tree, "tree3" );
				break;
			case "treefinal":
				//go directly to the final tree
				self find_immediate_zipline( a_zipline_current_tree, "treefinal" );
				break;
			default:
				break;
				
		}
	}
	else if( str_current_tree === "tree5" )
	{
		switch( str_dest_tree )
		{
			//in pretty much every case except the treefinal, I need to go back to tree3 initially
			case "tree1":
				self find_immediate_zipline( a_zipline_current_tree, "tree3" );
				break;
			case "tree2":
				self find_immediate_zipline( a_zipline_current_tree, "tree3" );
				break;
			case "tree3":
				self find_immediate_zipline( a_zipline_current_tree, "tree3" );
				break;
			case "tree4":
				self find_immediate_zipline( a_zipline_current_tree, "tree3" );
				break;
			case "treefinal":
				self find_immediate_zipline( a_zipline_current_tree, "treefinal" );
				break;
			default:
				break;				
		}
	}
}

//self is an AI
//finds out what zipline start position I need to use to get closer to the player. Needed for zipline_AI()
function find_immediate_zipline( a_current_tree, str_dest_tree )
{
	self endon( "death" );
	self endon( "stop_zipline_AI" );
	
	str_zipline = a_current_tree[0].targetname;
	
	foreach( s_zipline_start in a_current_tree )
	{
		//make sure I actually have an endpoint
		if( isdefined( s_zipline_start.target ) )
		{
			s_end = struct::get( s_zipline_start.target, "targetname" );
		}
		else
		{
			continue;
		}
		
		if ( s_end.script_label === str_dest_tree )
		{
			//if the current s_zipline_start's endpoint is on the tree I need to get to, use current s_zipline_start as my target and move to start that zipline
			str_zipline = s_zipline_start.targetname;
			break;
		}
	}
	
	self thread track_zipline_AI();
	
	self.target = str_zipline;
	self zipline_AI();
}

//self is an AI
//checks if the player has reached the tree AI is on, while the AI was on the way to the player's now old tree. If player gets there, cancel run to zipline and go back into regular combat
function track_zipline_AI()
{
	self endon( "death" );
	self endon( "dismount_zipline" );
	self endon( "stop_zipline_AI" );
	
	while ( true )
	{		
		foreach( player in level.players )
		{
			if( player.str_current_tree === self.str_current_tree )
			{
				if( self.b_using_zipline === false )
				{
					self ClearForcedGoal();
					self ai::set_ignoreall( false );
					self notify( "stop_zipline_AI" );
				}
			}
		}
		
		wait 0.5;
	}
}

function restaurant_zipline_icon()
{
	v_offset = ( 0, 0, 0 );
	
	a_t_ziplines = GetEntArray( "trigger_restaurant_zipline" , "targetname" );
		
	for ( i = 0; i < a_t_ziplines.size; i++ )
	{
		a_t_ziplines[i] SetCursorHint( "HINT_NOICON" );
		
		gobj_visuals = [];
		
		e_use_object = gameobjects::create_use_object( "allies" , a_t_ziplines[i], gobj_visuals, v_offset , undefined );
		e_use_object gameobjects::set_visible_team( "any" );
		e_use_object gameobjects::set_3d_icon( "friendly", "t7_hud_prompt_push_64" );	
		e_use_object thread gameobjects::hide_icon_distance_and_los( (1,1,1), 450, false );
	}
}

function zipline_icon()
{
	v_offset = ( 0, 0, 0 );
	
	a_t_ziplines = GetEntArray( "trigger_zipline" , "targetname" );
		
	foreach( t_zipline in a_t_ziplines )
	{
		t_zipline SetCursorHint( "HINT_NOICON" );
		
		t_zipline.gobj_visuals = [];
		
		t_zipline.e_use_object = gameobjects::create_use_object( "allies" , t_zipline, t_zipline.gobj_visuals, v_offset , undefined );
		t_zipline.e_use_object gameobjects::set_visible_team( "any" );
		t_zipline.e_use_object gameobjects::set_3d_icon( "friendly", "t7_hud_prompt_push_64" );	
		t_zipline.e_use_object thread gameobjects::hide_icon_distance_and_los( (1,1,1), 450, false );
	}	
}


//============================================================
// trigger thread for activating the player dive off the last supertree
// should only play on the specific player that activated the trigger
function playerdive_supertrees_setup()
{
	trig_playerdive = GetEnt( "trig_supertrees_playerdive_play", "targetname" );
	Assert( isdefined ( trig_playerdive ), "trig_supertrees_playerdive_play trigger needed to play scene" );
	
	level thread util::single_thread( trig_playerdive, &player_dive_start );
	
	level thread scene::add_scene_func( "cin_bio_14_01_treejump_vign_dive", &hendricks_dive, "done" );
}

function hendricks_dive( str_scene )
{
	level flag::set( "hendricks_dive" );
}

//self is the trigger that starts this scene
function player_dive_start()
{
	//Wait for someone to activate the trigger
	while ( isdefined ( self ) )
	{
		self trigger::wait_till();
			
		//self.who is the player who hit this trigger
		player = self.who;
		
		//thread to make sure this doesn't prevent co-op players from triggering their dive
		player thread player_dive_finish( self );
		player thread player_hits_water();
	}
}

//self is a player
function player_dive_finish( trigger )
{
	self endon( "death" );
	
	trigger SetInvisibleToPlayer( self );
	
	//make player invulnerable, play scene, and make player vulnerable again when the scene is done
	self EnableInvulnerability();
	
	//wait for scene to finish before making player vulnerable again
	level scene::play( "cin_bio_14_01_treejump_1st_dive", self );
	
	wait 2; //allow a couple seconds of invulnerability after the player lands in swamp for safety

	trigger SetVisibleToPlayer( self );
	self DisableInvulnerability();
}

function player_hits_water()  //self = player
{
	self endon( "disconnect" );
	
	self waittill( "notetrack_splash" );
	
	Earthquake( 0.6, 3.0, self.origin, 100 );
	
	self PlayRumbleOnEntity( "grenade_rumble" );
}
