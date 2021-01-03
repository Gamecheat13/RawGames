
//
// Events 2 - 4
//
// cp_prologue_enter_base.gsc
//

#using scripts\codescripts\struct;

#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\cp\_dialog;
#using scripts\cp\_load;
#using scripts\cp\_objectives;
#using scripts\cp\_skipto;
#using scripts\cp\_spawn_manager;
#using scripts\cp\_util;

#using scripts\cp\gametypes\_spawning;
#using scripts\cp\voice\voice_prologue;

#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\colors_shared;
#using scripts\shared\doors_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\turret_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\vehicle_ai_shared;

#using scripts\cp\cp_mi_eth_prologue;
#using scripts\cp\cp_mi_eth_prologue_fx;
#using scripts\cp\cp_mi_eth_prologue_sound;
#using scripts\cp\cp_prologue_hangars;
#using scripts\cp\cp_prologue_robot_reveal;
#using scripts\cp\cp_prologue_util;

#precache( "objective", "cp_level_prologue_locate_the_minister" );	// locate the minister objective
#precache( "objective", "cp_level_prologue_exit_control_tower" );	// follow hendricks objective
#precache( "objective", "cp_standard_breadcrumb" );

	
//*****************************************************************************
// EVENT 2: Nrc Knocking
//*****************************************************************************

#namespace nrc_knocking;


function nrc_knocking_start()
{
	nrc_knocking_precache();
	level thread nrc_knocking_main();	
}

// DO ALL PRECACHING HERE
function nrc_knocking_precache()
{
	
}

// Event Main Function
function nrc_knocking_main()
{
	if( !IsDefined(level.ai_hendricks) )
	{
		level.ai_hendricks = util::get_hero( "hendricks" );
		cp_mi_eth_prologue::init_hendricks( "skipto_nrc_knocking_hendricks" );
	}
	
	level flag::wait_till( "all_players_spawned" );	
	level cp_prologue_util::spawn_coop_player_replacement( "skipto_nrc_knocking" );
	
	// make sure AIs don't running into each other
	if( isDefined( level.ai_ally_01 ))
	{
		level.ai_ally_01.goalradius = 16;	
		level.ai_ally_01 SetGoal( GetNode( "ally01_start_node", "targetname" ) );
	}
	
	if( isDefined( level.ai_ally_02 ))
	{
		level.ai_ally_02.goalradius = 16;	
		level.ai_ally_02 SetGoal( GetNode( "ally02_start_node", "targetname" ) );
	}
	
	if( isDefined( level.ai_ally_03 ))
	{
		level.ai_ally_03.goalradius = 16;	
		level.ai_ally_03 SetGoal( GetNode( "ally03_start_node", "targetname" ) );
	}
	
	objectives::set( "cp_level_prologue_locate_the_minister" );
	
	// hendricks walks to the door and idle there anim
	
	while(scene::is_playing("cin_pro_01_01_airtraffic_1st_interact_intro")) //played in intro.gsc
	{
		wait .1;
	}

	wait 1;
	
	level thread plane_vign();
	
	
	level thread nrc_knocking_hendricks_opens_door();		
	level thread scene::play( "cin_pro_02_01_knocking_vign_approach_opendoor" , level.ai_hendricks );	// hendricks open the door anim
		
	level thread enemies_killed_failsafe();
	
	level flag::wait_till("objective_done_nrc");

	skipto::objective_completed( "skipto_nrc_knocking" );
}

function nrc_knocking_hendricks_opens_door()
{    
	level waittill( "button_press" );
	
	nd_nrc_knocking_hendrics_retreat = GetNode( "nd_nrc_knocking_hendrics_retreat" , "targetname" );
   	level.ai_hendricks setGoal( nd_nrc_knocking_hendrics_retreat , true );
   	
	// Unlock and open the door
    s_door_1 = struct::get( "prologue_nrc_kocking_door1", "targetname" );
    [[s_door_1.c_door]]->unlock();
    [[s_door_1.c_door]]->open();

    s_door_2 = struct::get( "prologue_nrc_kocking_door2", "targetname" );
    [[s_door_2.c_door]]->unlock();
    [[s_door_2.c_door]]->open();
    
    e_sight_block = getEnt( "nrc_knocking_door_sight_clip" , "targetname" );
    e_sight_block MoveTo( e_sight_block.origin + ( 0, 0, 1000) , 0.01 );
      
    level scene::play( "cin_pro_02_01_knocking_vign_nrc_breach_soldiers", "scriptbundlename" );   // Guards outside the door anim 
}

function enemies_killed_failsafe()
{
	
	//wait til all the guys are dead
	spawner::waittill_ai_group_cleared( "tower_guards" );
	
	//trigger sets flag objective_done_nrc
	trigger::use("trig_control_room_exit", "targetname");
}

function plane_vign()
{
	level flag::wait_till("plane_vign");

	vh_plane = vehicle::simple_spawn_single("veh_plane_landing");
	nd_start = GetVehicleNode( vh_plane.target, "targetname" );
    vh_plane AttachPath( nd_start );
    vh_plane StartPath();
    
	nd_rumble = GetVehicleNode( "nd_rumble", "script_noteworthy" );
	nd_rumble waittill( "trigger" );
	Earthquake( 0.3, 0.5, nd_rumble.origin, 1000 );
	
    
	vh_plane waittill( "reached_end_node" );
	vh_plane Delete();
}

//*****************************************************************************
// EVENT 3: Blend In
//*****************************************************************************

#namespace blend_in;


function blend_in_start()
{
	blend_in_precache();
	
	spawner::add_spawn_function_group( "guy_running" , "script_noteworthy", &ai_running_think );				// guys running outside the tower 
	spawner::add_spawn_function_group( "blend_in_tarmac_soldiers" , "script_noteworthy", &set_ai_ignore );		// soldiers AIs standing at the tarmac area
	spawner::add_spawn_function_group( "start_through_take_out_guards" , "script_aigroup", &set_ai_ignore );		// soldiers AIs standing at the tarmac area
	
	
	level thread blend_in_main();
}

// DO ALL PRECACHING HERE
function blend_in_precache()
{
	
}

// Event Main Function
function blend_in_main()
{
	if( !IsDefined(level.ai_hendricks) )
	{
		level.ai_hendricks = util::get_hero( "hendricks" );
		cp_mi_eth_prologue::init_hendricks( "skipto_blend_in_hendricks" );
	}
	
	level flag::wait_till( "all_players_spawned" );
	level cp_prologue_util::spawn_coop_player_replacement( "skipto_blend_in" );
	
	//set everyone CQB
	level.ai_hendricks ai::set_behavior_attribute( "cqb", true );
	a_allies = cp_prologue_util::get_ai_allies();
	foreach (e_ally in a_allies)
	{
		e_ally ai::set_behavior_attribute( "cqb", true );
	}
	
	//setup tarmac and tower vignettes 
	level thread tarmac_vingnettes();
	
	//this function drives the section
	level thread hendricks_movement_handler();
	
	//handles AI behaviors
	level thread set_allies_pacifist();
	
	//wait til hendricks opens the doors
	level waittill( "tower_doors_open" );
	
	//wait til the player moves up to the tunnel
	level flag::wait_till( "player_entering_tunnel" );
		
	objectives::complete( "cp_standard_breadcrumb", level.s_tarmac_obj );
	
	skipto::objective_completed( "skipto_blend_in" );
}

function tarmac_vingnettes()
{
	
	//setup wounded guys in tower
	e_spawner = GetEnt("spawner_tsa_guard", "targetname");
	level thread blend_in_tsa_guard(e_spawner, "cin_gen_m_wall_rightleg_wounded");
	e_spawner = GetEnt("spawner_tsa_guard2", "targetname");
	level thread blend_in_tsa_guard(e_spawner, "cin_gen_m_floor_head_wounded");
	
	//spawn guys on balcony in tunnel
	level thread tunnel_balcony_guys();
	
	level thread play_fire_scene();	
	level thread fxanim_plane_explosion();
	level thread fxanim_plane_explosion_backup();
	//spawn in guard for hendricks to assassinate
	level thread tunnel_entrance_guard();
	
	//trucks come out of the tunnels as player leaves tower

	//firetrucks move in as player moves out of tower
	//level thread blend_in_fire_truck_blocker(); commented out for future anim reference
	
	//handles guys running out of the building, visible from the tower
	level thread guys_running_group1();
	//handles guys running out of the tunnel
	//level thread spawn_tarmac_runners(); doesn't work
	//plays all the anims of the bodies and wounded on tarmac
	level thread tarmac_vign_anims();
}

function hendricks_movement_handler()
{
	//moves hendricks in front of the wheel
	level thread scene::play( "cin_pro_03_01_blendin_vign_movedown_tower_firststairs" );
	
	level waittill( "tower_hendricks_at_wheel" );
	level flag::wait_till( "tower_move_hendricks1" );
	//moves him under the wheel, near the window
	level thread scene::play( "cin_pro_03_01_blendin_vign_movedown_tower_moveunderwheel" );
	
	level waittill( "tower_hendricks_at_security" );
	level flag::wait_till( "tower_move_hendricks3" );
	//moves him down to door
	level thread scene::play( "cin_pro_03_01_blendin_vign_movedown_tower_movetodoor" );
	
	//wait til player gets to bottom
	level waittill( "tower_hendricks_at_bottom" );
	level flag::wait_till( "trigger_obj_cross_tarmac_start" ); //TODO: replace this with an iswithin check
	
	level thread door_handler();
	
	//Hendricks - Head straight across the tarmac.  Don't get too close or make too much noise, or they will see through our disguise.
	level.ai_hendricks thread dialog::say( "hend_head_straight_across_0" );
		
	//then play the exit scene
	level scene::play( "cin_pro_03_02_blendin_vign_tarmac_cross" );
	
	/* keeping stub out around for reference
	nd_node = GetNode( "hendricks_tarmac_goal", "targetname" );
	level.ai_hendricks SetGoal( nd_node, true );	
	level.ai_hendricks waittill( "goal" );
	
	//wait til truck arrives
	*/
	
	nd_node = GetNode( "hendricks_tunnel_goal", "targetname" );
	level.ai_hendricks SetGoal( nd_node, true );	
	level.ai_hendricks waittill( "goal" );
	
	if (!flag::get("player_entering_tunnel"))
	{
		//follow hendricks objective
		level.s_tarmac_obj = struct::get( "struct_tarmac_obj" , "targetname" );
		objectives::set( "cp_standard_breadcrumb" , level.s_tarmac_obj );				
	}
}

function set_allies_pacifist()
{

	trigger::wait_till( "trigger_gather_and_stealth_warning" );
	
	//set the AI and hendricks to not break stealth
	level.ai_hendricks.pacifist = true;
	level.ai_hendricks.ignoreme = true;
	
	if( isDefined( level.ai_ally_01 ))
	{
		level.ai_ally_01.pacifist = true;
		level.ai_ally_01.ignoreme = true;
	}
	
	if( isDefined( level.ai_ally_02 ))
	{
		level.ai_ally_02.pacifist = true;
		level.ai_ally_02.ignoreme = true;
	}
	
	if( isDefined( level.ai_ally_03 ))
	{
		level.ai_ally_03.pacifist = true;
		level.ai_ally_03.ignoreme = true;
	}

	//wait til hendricks opens the doors
	level waittill( "tower_doors_open" );
	
	//turn off weapons, let ai move normally
	level.ai_hendricks ai::set_behavior_attribute( "cqb", false);
	a_allies = cp_prologue_util::get_ai_allies();
	array::thread_all( a_allies, &ai::set_behavior_attribute, "cqb", false );
	array::run_all( level.players, &SetLowReady, true );
	
	//gets rid of the AI buddies
	level thread tarmac_move_ai_allies();
	
	//hendricks calls out orders to allies to split up
	if( isDefined( level.ai_ally_01 ) || isDefined( level.ai_ally_02 ) || isDefined( level.ai_ally_03 ))
	{
		level.ai_hendricks dialog::say( "Player follow me. The rest of the squads head to the other tunnel." );
	}
}

function door_handler()
{
	e_blend_in_control_tower_exit_sight_blocker = getEnt( "blend_in_control_tower_exit_sight_blocker" , "targetname" );
	e_blend_in_control_tower_exit_door = getEnt( "blend_in_control_tower_exit_door" , "targetname" );

	//wait til notetrack in cin_pro_03_02_blendin_vign_tarmac_cross
	level waittill("tarmac_hendricks_moving");
		
	//TODO: delete this when door is animated
	e_blend_in_control_tower_exit_sight_blocker MoveTo( e_blend_in_control_tower_exit_sight_blocker.origin + ( 0, 0, 1000) , 0.01 );
	e_blend_in_control_tower_exit_door MoveTo( e_blend_in_control_tower_exit_door.origin + ( 0, 0, 120) , 1.5 );
	e_blend_in_control_tower_exit_door playsound ("evt_garage_door_open");
	
	level notify( "tower_doors_open" );
}

// move friendlies and delete them 
function tarmac_move_ai_allies()
{
	trigger::wait_till( "tarmac_move_friendies" );
	
	if( isAlive( level.ai_ally_01 ) )
	{			
		level.ai_ally_01 thread setgoal_then_delete( "ally01_tunnel_goal" );			
	}
	
	if( isAlive( level.ai_ally_02 ) )
	{
		level.ai_ally_02 thread setgoal_then_delete( "ally02_tunnel_goal" );		
	}
	
	if( isAlive( level.ai_ally_03 ) )
	{
		level.ai_ally_03 thread setgoal_then_delete( "ally03_tunnel_goal" );		
	}	
}

// self = AI
function setgoal_then_delete( node )
{
	target_node = GetNode( node, "targetname" );
	self SetGoal( target_node, true );	
	self waittill( "goal" );
	self delete();
}

function tunnel_balcony_guys()
{
	spawner::simple_spawn("balcony_guy1");
	spawner::simple_spawn("balcony_guy2");
	
	level trigger::wait_till("take_out_guards_color_trigger");
	spawner::simple_spawn("balcony_guy3");
	
}

function tunnel_entrance_guard()
{
	sp_tunnel_entrance_guard = getEnt( "tunnel_entrance_guard" , "targetname" );
	level.ai_tunnel_entrance_guard = sp_tunnel_entrance_guard spawner::spawn( true );
	
	level.ai_tunnel_entrance_guard.ignoreme = true;
	level.ai_tunnel_entrance_guard.ignoreall = true;
}

// guys at the plane crash runway area
function tarmac_vign_anims()
{

	level thread scene::play( "cin_gen_m_floor_armdown_onback_deathpose" );
	level thread scene::play( "cin_gen_m_floor_armdown_onfront_deathpose" );
	level thread scene::play( "cin_gen_m_floor_leftleg_wounded" );
	level thread scene::play( "cin_gen_m_wall_legspread_armdown_leanleft_deathpose" );
	
	//anims
	level thread scene::play( "sc_tarmac_headinjury", "targetname" );
	level thread scene::play( "injured_carried1", "targetname" );
	
	trigger::wait_till( "trig_plane_tail_explosion" );
	level thread scene::play( "injured_carried2", "targetname" );	
}

// guys running when you look out the first window of tower
function guys_running_group1()
{
	spawn_manager::enable( "sm_guy_running" );	
	level flag::wait_till( "trigger_obj_cross_tarmac_start" );
	spawn_manager::kill( "sm_guy_running" );	
}

function spawn_tarmac_runners()
{
	spawner::add_spawn_function_group( "tarmac_running_guy" , "targetname",  &take_out_guards::sprint_and_die );
	spawn_manager::enable( "sm_tarmac_run_guys" );
}

// the crash plan fx anim, landing gear is inside the tower, tail and head are at the runway
function fxanim_plane_explosion()
{
	// the plane landing gear
	trigger = trigger::wait_till( "trig_landing_gear" );
	level thread scene::play( "landing_gear_anim", "targetname" );
	Earthquake( 0.3, 0.5, trigger.origin, 1000 );
	trigger.who PlayRumbleOnEntity( "tank_rumble" );
	
	// the plane tail explosion
	trigger = trigger::wait_till( "trig_plane_tail_explosion" );
	level thread scene::play( "plane_tail_explosion", "targetname" );
	Earthquake( 0.4, 0.7, trigger.origin, 1000 );
	trigger.who PlayRumbleOnEntity( "tank_damage_heavy_mp" );
	
	// the plane cockpit explosion
	//trigger::wait_till( "blend_in_prime_explosions" );
	loc = GetEnt( "trig_lookat_explosion", "targetname" );
	level waittill ("explosion_blast");
	level thread scene::play( "plane_cockpit_explosion", "targetname" );	
	exploder::exploder( "fx_exploder_plane_exp" );
	Earthquake( 0.7, 1, loc.origin, 1000 );
	array::run_all(level.players, &PlayRumbleOnEntity, "tank_damage_heavy_mp");
}

function fxanim_plane_explosion_backup()
{
	level flag::wait_till( "explosion_fallback_flag" );
	trigger::use( "trig_lookat_explosion");
}

// self == AI
// guy run to the goal then delete
function ai_running_think()
{
	self endon( "death" );
	
	self ai::set_ignoreme( true );
	self ai::set_ignoreall( true );
	self.goalradius = 8;	
	self PushActors( true );

	if( isdefined( self.target ) )
	{
		n_goalradius = self.goalradius;
		nd = GetNode( self.target, "targetname" );
		if( isdefined( nd ) )
		{
			self SetGoal( nd, true );
			self waittill( "goal" );
			self delete();	
		}		
	}
}

// fire truck anim near the fxanim plane tail location
function play_fire_scene()
{
	level scene::play( "cin_pro_03_02_blendin_vign_attendfire" );	
}

// the crawling and wounded guys inside the tower
function blend_in_tsa_guard(spawner, scene)
{
	trigger::wait_till( "trig_fire_trucks" );
	
	ai_guy = spawner::simple_spawn_single( spawner);
	
	ai_guy ai::set_ignoreall( true );
	ai_guy ai::set_ignoreme( true );
	ai_guy.health = Int(ai_guy.health * .25);
	ai_guy.dontDropWeapon = true;
	
	level thread scene::play( scene , ai_guy );
	
	//prevents writhing guys from popping up after shooting them
	ai_guy waittill( "death" );
	
	ai_guy StartRagdoll( true );	
}

function blend_in_fire_truck_blocker()
{
	//spawn in a firetruck to block an open space by the tower
	sp_firetruck_1 = vehicle::simple_spawn_single("fire_truck_1");
	sp_firetruck_1 thread vehicle::go_path();	
	sp_firetruck_1 thread vehicle_disconnect_path();	

	//spawn in the firetruck that enters the scene	
	sp_firetruck_2 = vehicle::simple_spawn_single("fire_truck_2");
	sp_firetruck_2 thread vehicle::go_path();
	
	//move in the truck that's putting out the fire to the left of the plane
	level flag::wait_till( "trigger_obj_cross_tarmac_start" );	
	sp_firetruck_5 = vehicle::simple_spawn_single("fire_truck_5");
	sp_firetruck_5 thread vehicle::go_path();	
	sp_firetruck_5 thread vehicle_disconnect_path();
	
	level waittill( "tower_doors_open" );
	wait 3;//blockout timing for the firetruck moving into the players path
	n_pathnode = GetVehicleNode("fire_truck_2_second_path", "targetname");
	sp_firetruck_2 AttachPath(n_pathnode);
	sp_firetruck_2 StartPath();
	sp_firetruck_2 thread vehicle_disconnect_path();
	
	
	
}

function vehicle_disconnect_path()
{
	self waittill( "reached_end_node" );
	self DisconnectPaths();
}

// self = ai
function set_ai_ignore()
{
	self.ignoreme = true;
	self.ignoreall = true;
}


//*****************************************************************************
// EVENT 4: Take Out Guards
//*****************************************************************************

#namespace take_out_guards;

function take_out_guards_start()
{
	take_out_guards_precache();	
	
	spawner::add_spawn_function_group( "tunnel_running_guy" , "targetname",  &sprint_and_die );		// these are the guys running with the truck inside the tunnel
	spawner::add_spawn_function_group( "tunnel_runners" , "script_noteworthy",  &sprint_and_die );		// these are the guys running with the truck inside the tunnel
	
	
	level thread take_out_guards_main();
}

// DO ALL PRECACHING HERE
function take_out_guards_precache()
{	
	
}

// Event Main Function
function take_out_guards_main()
{
	if( !IsDefined(level.ai_hendricks) )
	{
		level.ai_hendricks = util::get_hero( "hendricks" );
		cp_mi_eth_prologue::init_hendricks( "skipto_take_out_guards_hendricks" );
	}	

	level.ai_hendricks.pacifist = true;
	level.ai_hendricks.ignoreme = true;
	
	level flag::wait_till( "all_players_spawned" );
	array::run_all(level.players, &SetLowReady, true);
	
	e_r_door = getEnt( "tunnel_vault_door_r" , "targetname" );	
	e_r_door disconnectpaths();	
	e_l_door = getEnt( "tunnel_vault_door_L" , "targetname" );	
	e_l_door disconnectpaths();	
	
	
	level thread tunnel_vignettes();
	level thread take_out_guards_objective_handler();
	level thread spawn_tunnel_trucks();
	level thread tunnel_turret();

	level.ai_hendricks hendricks_take_out_guard();

}

// hendricks take out the first security guard at the tunnel
function hendricks_take_out_guard()
{
	level thread scene::play( "cin_pro_04_01_takeout_vign_kiosk_kill" );
	
	tunnel_gate_l1 = GetEnt( "tunnel_securitydoor_l1", "targetname" );
	tunnel_gate_l2 = GetEnt( "tunnel_securitydoor_l2", "targetname" );
	tunnel_gate_r1 = GetEnt( "tunnel_securitydoor_r1", "targetname" );
	tunnel_gate_r2 = GetEnt( "tunnel_securitydoor_r2", "targetname" );
	
	pos_left = GetEnt("pos_tunnel_doors_left", "targetname");
	pos_right = GetEnt("pos_tunnel_doors_right", "targetname");
	
	level waittill("hendricks_through_door");
	
	level thread hend_taylor_dialog();
		
	tunnel_gate_l1 Moveto( pos_left.origin, 1 );
	tunnel_gate_l2 Moveto( pos_left.origin, 1 );
	tunnel_gate_r1 Moveto( pos_right.origin, 1 );
	tunnel_gate_r2 Moveto( pos_right.origin, 1 );
		
	// move hendrick after animation	
	nd_node1 = GetNode( "node_hendricks_tunnel_rear", "targetname" );
	self ai::set_behavior_attribute( "disablearrivals", true );	
	self.goalradius = 16;
	while (1)
	{
		self SetGoal( nd_node1, true );
		self waittill( "goal" );
		if (!IsDefined(nd_node1.target))
		{
			self ai::set_behavior_attribute( "disablearrivals", false );
			break;
		}
		nd_node1 = GetNode( nd_node1.target, "targetname" );
	}
}
function tunnel_vignettes()
{	
	//start spawning guys running around
	spawn_manager::enable( "tunnel_spawners1" );
	spawn_manager::enable( "tunnel_spawners2" );
	
	level thread forklift_anim();
}

function forklift_anim()
{
	//wait til player goes thru door
	trigger::wait_till( "trigger_obj_enter_tunnels_end" );
	
	//play anim
	level thread scene::play( "forkilft_anim", "targetname" );	
}

// TODO: need a real turret with AIs mount on it.
function tunnel_turret()
{	
	spawner::simple_spawn_single( "tunnel_turret" );
	
	e_turret = GetEnt ("tunnel_turret_ai", "targetname");

}

function hend_taylor_dialog()
{
	level.ai_hendricks dialog::say( "hend_let_s_get_this_done_0" );	
	level.ai_hendricks dialog::say( "tayr_i_hear_you_hendrick_0" );	
}
	

function spawn_tunnel_trucks()
{	
	level waittill( "nt_body_drop" );				// notetrack set in the anim "cin_pro_04_01_takeout_vign_kiosk_kill" 
	
	for (i = 0; i < 3; i++)
	{
		sp_tunneltruck_1 = vehicle::simple_spawn_single("tunnel_truck3");
		sp_tunneltruck_1 thread tunneltruck( "tunnel_truck_interior_node" );
		wait 2.5;
	}
	
	level thread take_out_guards_close_security_door_R();
	level thread take_out_guards_close_security_door_L();	
}

// self == vehicle
function tunneltruck( nd_start )
{
	nd_truck_start = GetVehicleNode( nd_start, "targetname" );	
	
	self thread vehicle::get_on_and_go_path( nd_truck_start );
	self waittill( "reached_end_node" );
	self delete();
}


// self == AI
function sprint_and_die()
{
	self endon( "death" );
	
	self.goalradius = 64;
	self ai::set_ignoreall( true );
	self ai::set_ignoreme( true );
	self ai::set_behavior_attribute( "sprint", true );
	self waittill( "goal" );
	self delete();
}


function take_out_guards_close_security_door_R()
{
	level.is_security_door_closed = 1;
	e_door = GetEnt( "tunnel_vault_door_r" , "targetname" );
	e_door playsound ("evt_tunnel_door_start");
	e_door disconnectpaths();	
	e_door RotateYaw( -90 , 15.0 , 1.0 , 1.0 );
}

function take_out_guards_close_security_door_L()
{
	e_door = GetEnt( "tunnel_vault_door_L" , "targetname" );	
	e_door disconnectpaths();
	e_door RotateYaw( 90 , 15.0 , 1.0 , 1.0 );
}

function take_out_guards_objective_handler()
{
	level flag::wait_till("cleanup_tarmac_guys");
	a_take_out_guards_triggers = GetEntArray( "take_out_guards_color_trigger" , "targetname" );

	foreach( trigger in a_take_out_guards_triggers )
	{
		trigger Delete();
	}
	
	level thread clean_up_enemies_through_take_out_guards();
}

function clean_up_enemies_through_take_out_guards()
{
	
	trigger::wait_till( "trigger_clean_up_start_through_take_out_guards" );
	
	if( !IsDefined( level.is_security_door_closed) )
	{
	   	level.is_security_door_closed = 0;
	}
	
	if( level.is_security_door_closed != 1 )
	{
		level thread take_out_guards_close_security_door_R();
		level thread take_out_guards_close_security_door_L();
	}

	level.ai_hendricks.ignoreme = false;

	if (scene::is_active("cin_pro_03_02_blendin_vign_attendfire"))
	{
		level scene::stop( "cin_pro_03_02_blendin_vign_attendfire" );
	}
	
	a_clean_up_group_start_through_take_out_guards = GetAIArray( "start_through_take_out_guards" , "script_aigroup" );
	
	foreach( ai_entity in a_clean_up_group_start_through_take_out_guards )
	{
		if ( IsAlive( ai_entity ) )
		{
			ai_entity kill();
		}
	}
}