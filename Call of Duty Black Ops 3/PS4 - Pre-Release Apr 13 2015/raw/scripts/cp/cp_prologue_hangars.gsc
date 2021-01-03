
//
// Events 10 - 13
//
// prologue_hangars.gsc
//

#using scripts\codescripts\struct;

#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\cp\_dialog;
#using scripts\cp\_load;
#using scripts\cp\_objectives;
#using scripts\cp\_oed;
#using scripts\cp\_skipto;
#using scripts\cp\_spawn_manager;
#using scripts\cp\_util;

#using scripts\cp\cp_mi_eth_prologue_fx;
#using scripts\cp\cp_mi_eth_prologue_sound;
#using scripts\cp\cp_prologue_apc;
#using scripts\cp\cp_prologue_util;
#using scripts\cp\cp_prologue_cyber_soldiers;
#using scripts\shared\clientfield_shared;

#using scripts\cp\cybercom\_cybercom_gadget_sensory_overload;	
#using scripts\cp\cybercom\_cybercom_gadget_firefly;	

#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\colors_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\turret_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\vehicle_ai_shared;


#precache( "objective", "cp_level_prologue_follow_pallas" );
#precache( "objective", "cp_level_prologue_exit_hangar" );
#precache( "objective", "cp_level_prologue_meet_theia" );
#precache( "objective", "cp_level_prologue_find_vehicle" );
#precache( "objective", "cp_level_prologue_bridge" );
#precache( "objective", "cp_standard_breadcrumb" );



	
#precache( "fx", "fire/fx_fire_hot_lg" );

//*****************************************************************************
// EVENT 10: Hangar
//*****************************************************************************

#namespace hangar;


function hangar_start()
{
	//if this is a skipto
	if( !IsDefined(level.ai_hendricks) )
	{
		intro_cyber_soldiers::move_lift();
	}
	
	hangar_precache();
	
	hangar_heros_init();
	
	//these decide if AI should be allowed to move or not
	spawner::add_spawn_function_group( "hangar01_balcony_ai", "script_noteworthy", &ai_think );
	spawner::add_spawn_function_group( "hangar01_cover" , "script_noteworthy", &ai_think_and_move );
	spawner::add_spawn_function_group( "catwalk_window_enemies" , "targetname", &ai_think_and_move );
	spawner::add_spawn_function_group( "catwalk_stair_enemy" , "targetname", &ai_ignore_then_move );
	spawner::add_spawn_function_group( "catwalk_battle_enemy_wave2" , "targetname", &ai_think_and_move );
	spawner::add_spawn_function_group( "2nd_hangar_enemies" , "script_noteworthy", &run_and_die );
	
	intro_cyber_soldiers::cyber_hangar_gate_close(.1);

	level thread hangar_main();
}

// DO ALL PRECACHING HERE
function hangar_precache()
{	
}

function hangar_heros_init()
{
	level.ai_prometheus ai::set_ignoreall( true );
	level.ai_prometheus ai::set_ignoreme( true );
	level.ai_prometheus.goalradius = 16;
	
	level.ai_theia ai::set_ignoreall( true );
	level.ai_theia ai::set_ignoreme( true );
	level.ai_theia.goalradius = 16;
	level.ai_theia.allowpain = false;
	level.ai_theia colors::set_force_color( "c" );
	
	
	level.ai_pallas ai::set_ignoreall( true );
	level.ai_pallas ai::set_ignoreme( true );
	level.ai_pallas.goalradius = 16;
	level.ai_pallas.allowpain = false;
	level.ai_pallas colors::set_force_color( "o" );
	
	level.ai_hyperion ai::set_ignoreall( true );
	level.ai_hyperion ai::set_ignoreme( true );
	level.ai_hyperion.goalradius = 16;
	level.ai_hyperion.allowpain = false;
	level.ai_hyperion colors::set_force_color( "p" );
	
	level.ai_hendricks.goalradius = 16;
	level.ai_hendricks.allowpain = false;
	
	level.ai_khalil ai::set_ignoreall( true );
	level.ai_khalil ai::set_ignoreme( true );
	level.ai_khalil.goalradius = 16;
		
	level.ai_minister ai::set_ignoreall( true );
	level.ai_minister ai::set_ignoreme( true );		
	level.ai_minister.goalradius = 16;		
}

// Event Main Function
function hangar_main()
{
	level flag::wait_till( "all_players_spawned" );	

	level thread scene::init("p7_fxanim_cp_prologue_hangar_window_kick_bundle");
	
	////////////////////////////////////////////////////////////////////
	// First hangar battle
	///////////////////////////////////////////////////////////////////
	 
	// Friendlies run to somewhere so that they dont run into each other
	level.ai_prometheus thread prometheus_hangar_goal();
	level.ai_theia thread theia_hangar_goal();
	level.ai_hyperion thread hyperion_hangar_goal();
	level thread allied_ai_movements();
	
	// VO - It's too dangerous on the tarmac.  We'll use the hangars as cover, follow me!
	level.ai_pallas thread dialog::say( "pall_it_s_too_dangerous_o_0" ); 
	
	//objectives::set( "cp_level_prologue_follow_pallas", level.ai_pallas );

	//this function handles pallas' movement through the hangars
	level.ai_pallas thread pallas_jump_hangar();
	
	
	level flag::wait_till( "pallas_jump_inside_catwalk" ); // trigger by hangar 2 windows
	spawner::simple_spawn( "catwalk_window_enemies");
	
	////////////////////////////////////////////////////////////////
	// Catwalk battle
	///////////////////////////////////////////////////////////////
		
	level flag::wait_till( "trig_catwalk_enemies" );
	spawn_manager::enable( "catwalk_enemy_wave2" );
	level thread catwalk_fxanim();

	level flag::wait_till( "friendlies_jump_out_window" );	// flag set just before exiting hangar 2
	
	skipto::objective_completed( "skipto_hangar" );
	
}


function allied_ai_movements()
{
	//reenable hendricks color chain
	level.ai_hendricks colors::enable();
	
	//get them set up in hangar 1
	trigger::use( "hangar_move_friendlies_1", "targetname" );	
	
	//run them to the door
	level flag::wait_till( "pallas_jump_inside_catwalk");
	node = GetNode( "minister_traversal_goal_1", "targetname" );
	level.ai_minister SetGoal( node, true );
	node = GetNode( "khalil_traversal_goal_1", "targetname" );
	level.ai_khalil SetGoal( node, true );
	node = GetNode( "hendricks_traversal_goal_1", "targetname" );
	level.ai_hendricks SetGoal( node, true );	
	
	//run the intro animation (with goto)
	level.ai_hendricks waittill( "goal" );
	level.ai_khalil waittill( "goal" );
	level.ai_minister waittill( "goal" );
	level scene::play("cin_pro_10_01_hangar_vign_traverse_hendricks_khalil_minister_move_01");

	//open the doors
	door_l = GetEnt( "hangar02_door_left", "targetname" );
	door_r = GetEnt( "hangar02_door_right", "targetname" );
	door_l RotateTo( door_l.angles + (0, 120, 0), 0.5 );
	door_r RotateTo( door_r.angles + (0, -120, 0), 0.5 );
	
	//run the second anim, get them into the hangar
	level scene::play("cin_pro_10_01_hangar_vign_traverse_hendricks_khalil_minister_move_02");
	
	//send them further up
	trigger::use( "t_hangar02_move_allies");
}

function pallas_jump_hangar()
{		
	//self is pallas
	//gets pallas to edge of hangar
	level.ai_pallas pallas_stun();
	
	//triggered as player approaches hangar
	level flag::wait_till( "pallas_jump_inside_catwalk" );
		
	//play double jump and window kick anims
	self scene::play( "cin_pro_10_01_hangar_vign_highmantle", self );	//double jump up	
	level thread scene::play("p7_fxanim_cp_prologue_hangar_window_kick_bundle"); // break the window
	self scene::play( "cin_pro_10_01_hangar_vign_kick", self );
	
	
	//Wait him here til player enters
	self SetGoal( self.origin, true);
	level flag::wait_till( "move_pallas_inside_catwalk");
	
	//get him to a cover node and shooting at baddies
	node = GetNode( "pallas_temp_catwalk_end", "targetname" );
	self SetGoal( node, true );
	self waittill( "goal" );
	
	//play firefly attack
	a_targets = GetEntArray("catwalk_window_enemies_ai", "targetname");	
	self cybercom_gadget_firefly::ai_activateFireFlySwarm(a_targets[0], true);
	
	//wait a bit til they land, then start firing
	wait .5;
	
	self ai::set_ignoreall( false );
	self ai::set_ignoreme( false );
	self SetGoal( node, true );
	
	level thread plane_hangar_breakout();
	
	level flag::wait_till("pallas_jump_to_window");
	
	level thread scene::add_scene_func("cin_pro_10_04_hangar_vign_leap_new_wing2window", &pallas_waiting_at_window, "done");
	
	//pallas goes across the plane and outside
	self thread scene::play( "cin_pro_10_04_hangar_vign_leap_new_wing2window" );	
	
}

function pallas_waiting_at_window(a_ents)
{
	level flag::set ("pallas_at_window");
}

function plane_hangar_breakout()
{
	//fight in first hangar is done
	spawner::waittill_ai_group_ai_count( "plane_hangar_catwalk_enemies", 0 );
	spawner::waittill_ai_group_ai_count( "catwalk_battle_enemy_wave2", 0 );
	
	trigger::use("trig_pallas_jump_to_window");
}

function pallas_stun()
{	
	spawner::add_spawn_function_group( "hangar01_enemy" , "script_aigroup", &hangar::init_stun_guys );
	
	level flag::wait_till( "trig_hangar01_enemies" ); // triggered as player leaves hangar 1
	
	spawn_manager::enable( "hangar01_enemies_wave1" );
	
	node = GetNode( "pallas_traversal_goal_2", "targetname" );
	self SetGoal( node, true );
	wait 2;
	
	a_targets = GetEntArray("hangar01_enemies_ai", "targetname");
	
	//script calls for these guys to get stunned permanently 
	self thread cybercom_gadget_sensory_overload::ai_activateSensoryOverload(a_targets, 1500000);
	
	//wait til pallas goes to node
	self waittill( "goal" );
}

function init_stun_guys()
{
	self ai::set_ignoreall( true );
}


function prometheus_vtol_hangar()
{
	e_target = GetEnt( "cyber_soldiers_hangar_target", "targetname" );
	self thread ai::shoot_at_target( "normal" , e_target , undefined , 100, 10000);	
}

function ai_teleport( ai_node )
{
	node = GetNode( ai_node, "targetname" );
	self ForceTeleport( node.origin, node.angles, true );
}

function ai_think_and_move()
{
	self endon( "death" );
	
	if( isdefined( self.target ) )
	{
		n_goalradius = self.goalradius;
		nd = GetNode( self.target, "targetname" );
		if( isdefined( nd ) )
		{
			self ai::force_goal( nd, 64, true, undefined, true );
		}
		if( isdefined( self.radius ) )
		{
			self.goalradius = self.radius;
		}
	}
}

function ai_ignore_then_move()
{
	self endon( "death" );
	
	self ai::set_ignoreall( true );
	self ai::set_ignoreme( true );
	
	if( isdefined( self.target ) )
	{
		n_goalradius = self.goalradius;
		nd = GetNode( self.target, "targetname" );
		if( isdefined( nd ) )
		{
			self ai::force_goal( nd, 64, true, undefined, true );
			self ai::set_ignoreall( false );
			self ai::set_ignoreme( false );
		}
		if( isdefined( self.radius ) )
		{
			self.goalradius = self.radius;
			
			
		}
	}
}

function run_and_die()
{
	self endon( "death" );
	
	self.goalradius = 16;
	self ai::set_ignoreall( true );
	self ai::set_ignoreme( true );
	
	if( isdefined( self.target ) )
	{
		n_goalradius = self.goalradius;
		nd = GetNode( self.target, "targetname" );
		if( isdefined( nd ) )
		{
			self SetGoal( nd, true );
			self waittill( "goal" );
			self kill();	
		}		
	}
}

function ai_think()
{
	
	self endon( "death" );
	
	self.goalradius = 16;
	
	if( IsDefined( self.target ) )
	{
		node = GetNode( self.target, "targetname" );
		self SetGoal( node, true );
	}
}

// self = Prometheus
function prometheus_hangar_goal()
{	
	//TODO: need to clean him up or send him somewhere or block the player from following
	node = GetNode( "prometheus_hangar_goal", "targetname" );
	self ForceTeleport( node.origin, node.angles, true );
}

function theia_hangar_goal()
{	
	//TODO: need to clean him up or send him somewhere or block the player from following
	node = GetNode( "theia_hangar_goal", "targetname" );
	self ForceTeleport( node.origin, node.angles, true );

}

function hyperion_hangar_goal()
{					
	//TODO: need to clean him up or send him somewhere or block the player from following
	node = GetNode( "hyperion_hangar_goal", "targetname");
	self ForceTeleport( node.origin, node.angles, true );
	
	
}

function catwalk_fxanim()
{
	//TODO: get this firing and turning off as appropriate
	trig = GetEnt( "wing_r", "targetname" );//trigger on the hangar 1 plane's right wing

	while ( true )
	{
		trig waittill( "trigger" );
		
		//fx of bullets being fired up through the wing
		exploder::exploder( "fx_exploder_wing_bullet01" );
		exploder::exploder( "fx_exploder_wing_bullet02" );
	}
	
}

// Pallas jumping animation



// cleanup enemies 
function cleanup( spawn_mgr_name, ai_groups_name )
{	
	spawn_manager::kill( spawn_mgr_name );
	
	group = spawner::get_ai_group_ai( ai_groups_name );
	
	array::thread_all( group,&kill );
}

function kill()
{
	self endon( "death" );
	
	self dodamage( self.health + 100, self.origin );
}

//*****************************************************************************
// EVENT 10: VTOL Collapse
//*****************************************************************************

#namespace vtol_collapse;


function vtol_collapse_start()
{
	//if this is a skipto
	if( !IsDefined(level.ai_hendricks) )
	{
		intro_cyber_soldiers::move_lift();
	}
	
	vtol_collapse_precache();
	
	vtol_collapse_heros_init();
	
	//these decide if AI should be allowed to move or not
	spawner::add_spawn_function_group( "ai_hangar03_cover" , "targetname", &hangar::ai_think );
	
	intro_cyber_soldiers::cyber_hangar_gate_close(.1);

	level thread vtol_collapse_main();
}

// DO ALL PRECACHING HERE
function vtol_collapse_precache()
{
	level flag::init( "door_close" );
}

function vtol_collapse_heros_init()
{
	level.ai_prometheus ai::set_ignoreall( true );
	level.ai_prometheus ai::set_ignoreme( true );
	level.ai_prometheus.goalradius = 16;
	
	level.ai_pallas ai::set_ignoreall( true );
	level.ai_pallas ai::set_ignoreme( true );
	level.ai_pallas.goalradius = 16;
	level.ai_pallas.allowpain = false;
	level.ai_pallas colors::set_force_color( "o" );
	
	level.ai_hendricks.goalradius = 16;
	level.ai_hendricks.allowpain = false;
	level.ai_hendricks ai::set_ignoreall( true );
	level.ai_hendricks ai::set_ignoreme( true );
	
	level.ai_khalil ai::set_ignoreall( true );
	level.ai_khalil ai::set_ignoreme( true );
	level.ai_khalil.goalradius = 16;
		
	level.ai_minister ai::set_ignoreall( true );
	level.ai_minister ai::set_ignoreme( true );		
	level.ai_minister.goalradius = 16;		
}

// Event Main Function
function vtol_collapse_main()
{
	level flag::wait_till( "all_players_spawned" );	
	
	level.ai_pallas thread pallas_jump_vtol_collapse();

	
	//set up goal volume for those pesky enemies in vtol
	e_vtol_goal_volume = GetEnt( "v_vtol_hangar_enemy_goal", "targetname");
	a_spawners = GetEntArray( "hangar3_enemy", "script_aigroup" );
	foreach (sp in a_spawners)
	{
		sp spawner::add_spawn_function( &cp_prologue_util::set_goal_volume, e_vtol_goal_volume );
	}
	
	//get pallas in double jump position
	
	
	//////////////////////////////////////////////////////////////////
	// moving to the 3rd hangar battle
	/////////////////////////////////////////////////////////////////
	level flag::wait_till( "move_friendlies_inside_3rd_hangar" );	// flag set after leaving hangar 2
	
	level.ai_hendricks ai::set_ignoreall( true );
	level.ai_hendricks ai::set_ignoreme( true );
	
	thread hangar::cleanup( "catwalk_enemy_wave2", "catwalk_battle_enemy_wave2");
	
	level flag::wait_till( "hanger3_battle_event" );	// flag set upon entering hangar 3
	level thread hangar2_backgroundai_cleanup();		// cleanup the background running AIs when all players hit the triggers
	
	level.ai_hendricks ai::set_ignoreall( false );
	level.ai_hendricks ai::set_ignoreme( false );
	
	level thread hangar3_enemies_wave1();
	
	// vtol collapse fxanim
	level thread fxanim_vtol_collapses_scene();
	
	// TODO: set this up as an anim with notetracks talking to fxanim_vtol_collapses_scene
	level thread hangar_gate_close();
	
	//fired by door closing anim
	level flag::wait_till( "door_close" );
	
	s_exit = struct::get( "hangar_back_defend", "targetname" );
	objectives::set( "cp_level_prologue_exit_hangar", s_exit );
	
	//temp function to turn off grenade spamming
	level thread jeep_alley::jeep_grenades_off();
	
	level flag::wait_till( "hanger3_backdoor" );
	
	
	objectives::complete( "cp_level_prologue_exit_hangar" );
	skipto::objective_completed( "skipto_vtol_collapse" );
}

function hangar3_enemies_wave1()
{	
	spawn_manager::enable( "sm_hangar3_door_spawners" );
	//spawn_manager::enable( "sm_hangar3_cover_spawners" );
	
	//once the door is closed, kill all enemies outisde
	level flag::wait_till( "door_close" );
	trig = GetEnt( "outside_hangar_check", "targetname" );
	a_ais = GetAITeamArray( "axis", "axis" );
	
	foreach( ai in a_ais )
	{
		if ( ai IsTouching( trig )  )
		{
			ai kill();
		}
	}
}


function hangar_gate_close()
{		
	
	level.ai_pallas ai::set_ignoreall( false );
	level.ai_pallas ai::set_ignoreme( false );
	
	level.ai_prometheus ai::set_ignoreall( true );
	level.ai_prometheus ai::set_ignoreme( true );

	hangar_gate_r = GetEnt( "hangar_gate_r", "targetname" );
	hangar_gate_r_pos = struct::get( "hangar_gate_r_pos", "targetname" );
	hangar_gate_r playsound ("evt_hangar_start_r");
	hangar_gate_r Moveto( hangar_gate_r_pos.origin, 8 );
	snd_hangar_r = spawn( "script_origin", (hangar_gate_r.origin));
	snd_hangar_r linkto (hangar_gate_r);
	snd_hangar_r playloopsound ( "evt_hangar_loop_r" );
	
	hangar_gate_l = GetEnt( "hangar_gate_l", "targetname" );
	hangar_gate_l_pos = struct::get( "hangar_gate_l_pos", "targetname" );
	hangar_gate_l playsound ("evt_hangar_start_l");
	hangar_gate_l Moveto( hangar_gate_l_pos.origin, 8 );
	snd_hangar_l = spawn( "script_origin", (hangar_gate_l.origin));
	snd_hangar_l linkto (hangar_gate_l);
	snd_hangar_l playloopsound ( "evt_hangar_loop_l" );
	
	hangar_gate_l waittill( "movedone" );
	hangar_gate_r playsound ("evt_hangar_stop_r");
	hangar_gate_l playsound ("evt_hangar_stop_l");
	snd_hangar_r stoploopsound ( .1 );
	snd_hangar_l stoploopsound ( .1 );	
	
	hangar_gate_r Disconnectpaths();
	hangar_gate_l Disconnectpaths();
		
	level flag::set( "door_close" );
} 

function fxanim_vtol_collapses_scene()
{	
	//wait some amount of time
	wait .7;
	//spawn in the vehicle and have it drive
	//TODO: Make this the right function!
	level thread vtol_apc_dialog();
	
	veh = vehicle::simple_spawn_single_and_drive( "vtol_collapse_apc" );
	veh SetTeam("axis");
	//wait til it gets into the garage and have it start firing
	level waittill( "VTOL_APC_fire" );
	veh turret::enable( 1, false );
	veh turret::enable( 2, false );
	
	//once it stops, wait a bit for it to shoot
	veh waittill( "reached_end_node" );
	wait 6;
	
	//have hendricks say "(Melodramatically): USE YOUR CYBER POWERS!!!"
	level.ai_hendricks thread dialog::say( "(Melodramatically): PALLAS, USE YOUR CYBER POWERS!!!" );
	//play vtol collapse
	wait 3;
	vtol = getent( "vtol_hangar_start", "targetname");
	vtol thread scene::play( "p7_fxanim_cp_prologue_vtol_hangar_bundle", vtol );
	//destroy jeep
	veh freeVehicle();
	
	target = getent( "jeep_vtol_target", "targetname");
	PlayFX( "explosions/fx_exp_generic_lg", target.origin );

	//player rumble here and screen shake
	foreach( e_player in level.players )
	{
		e_player PlayRumbleOnEntity( "tank_damage_heavy_mp" );
		Earthquake( 0.45, 1, e_player.origin, 128.0 );
	}
}

function vtol_apc_dialog()
{
	wait 2;//timing
	level.ai_pallas dialog::say("hend_incoming_find_cover_0");
}

// Pallas jumping animation
function pallas_jump_vtol_collapse() 
{		
	//wait til player gets outside
	level flag::wait_till( "move_friendlies_inside_3rd_hangar" );
	
	//have prometheus play his jump on jeep anim
	level thread prometheus_cover_fire();
	
	level flag::wait_till("pallas_at_window"); //fired at end of previous pallas animation via script
	
	level thread pallas_double_jump_dialog();
	
	//jump to next hangar
	self scene::play( "cin_pro_10_04_hangar_vign_leap_new_jump_across", self );	
	
	//TP to hangar 3 catwalk
	node = GetNode( "n_pallas_vtol_tp", "targetname" );
	level.ai_pallas ForceTeleport( node.origin, node.angles, true );	
}

function pallas_double_jump_dialog()
{
	level.ai_pallas dialog::say("diaz_move_into_the_next_h_0");
}


function prometheus_cover_fire()
{
	level waittill( "start_prometheus" );	//fired via notetrack in pallas anims
	
	level.ai_prometheus scene::play( "cin_pro_10_04_hangar_vign_coverfire_prometheus", level.ai_prometheus );
}

function hangar2_backgroundai_cleanup()
{
	trigger::wait_till( "kill_2nd_hangar_enemies" );	// fired upon entering hangar 3
	thread hangar::cleanup( "2nd_hangar_enemies_right", "2nd_hangar_enemy_right" );
}

//*****************************************************************************
// EVENT 11: Jeep Alley
//*****************************************************************************

#namespace jeep_alley;


function jeep_alley_start()
{
	jeep_alley_precache();
	
	jeep_alley_heros_init();
	
	//if this is a skipto
	if( !IsDefined(level.ai_hendricks) )
	{
		level thread jeep_grenades_off();
	}
	
	level thread jeep_alley_main();
}

//temp function
function jeep_grenades_off()
{
	//temp turning off grenades for enemies
	spawner::add_spawn_function_group( "jeep_alley_enemies", "script_aigroup", &prologue_util::remove_grenades );	
	
}

// DO ALL PRECACHING HERE
function jeep_alley_precache()
{
	level flag::init( "kill_jeep_guy" );
}

function jeep_alley_heros_init()
{		
	level.ai_theia ai::set_ignoreall( true );
	level.ai_theia ai::set_ignoreme( true );
	level.ai_theia.goalradius = 16;
	level.ai_theia.allowpain = false;
	level.ai_theia colors::set_force_color( "c" );
	
	level.ai_khalil ai::set_ignoreall( true );
	level.ai_khalil ai::set_ignoreme( true );
	level.ai_khalil.goalradius = 16;
		
	level.ai_minister ai::set_ignoreall( true );
	level.ai_minister ai::set_ignoreme( true );		
	level.ai_minister.goalradius = 16;	
	
	level.ai_hendricks ai::set_ignoreall( true );
	level.ai_hendricks ai::set_ignoreme( true );
	level.ai_hendricks.goalradius = 16;
	level.ai_hendricks.allowpain = false;	
}

// Event Main Function
function jeep_alley_main()
{
	level flag::wait_till( "all_players_spawned" );

	//e_orig = GetNode( "theia_tp_node", "targetname" );
	//level.ai_theia ForceTeleport( e_orig.origin, e_orig.angles, true );
	
	//Scene where theia smashes a dude into the door for like no reason; what a jerk
	level thread scene::play( "cin_pro_11_01_jeepalley_vign_engage_new_start" );
	
	level waittill ("theia_in_idle1"); //fired at the end of previous animation
	
	level thread scene::init("p7_fxanim_cp_prologue_plane_hanger_explode_bundle");
	
	//wait til player goes outside
	level flag::wait_till( "trig_player_exits_vtol" );
	
	vehicle::simple_spawn("jeep");
	
	level thread scene::play( "cin_pro_11_01_jeepalley_vign_engage_new_attack" );
	
	level waittill("theia_hide_gun"); //fired during previous animation
	
	//hide gun
	vh_jeep = GetEnt("jeep", "animname");

	//vh_jeep HidePart( "tag_weapon_attach", "", true );
	vh_jeep HidePart( "tag_weapon", "veh_t7_lmg_brm_world", true );
	
	level waittill ("theia_in_idle2"); //fired at the end of previous animation

	level.ai_theia thread theia_shoot_plane();
		
	skipto::objective_completed( "skipto_jeep_alley" );
	
}

function theia_shoot_plane()
{
	//self is hyperion here	
	
	level.ai_hendricks ai::set_ignoreall( false );
	level.ai_hendricks ai::set_ignoreme( false );

	//wait 1;
	//fire at plane
	e_target = GetEnt( "rpg_plane_target", "targetname" );
	self thread apc_shared::fire_missile_at_struct( self.origin + (0,0, 64 ), e_target.origin );
	wait 1;
	PlayFX( "explosions/fx_exp_generic_lg", e_target.origin );
	
	level thread scene::play("p7_fxanim_cp_prologue_plane_hanger_explode_bundle");
	
	//player rumble here and screen shake
	foreach( e_player in level.players )
	{
		e_player PlayRumbleOnEntity( "tank_damage_heavy_mp" );
		Earthquake( 1.0, 1.5, e_player.origin, 128.0 );
	}
		
	//set objective as getting to the bridge after theia shoots the plan
	level.bridge_marker = struct::get( "bridge_obj", "targetname" );
	objectives::set( "cp_level_prologue_bridge", level.bridge_marker );
	
	level.ai_theia dialog::say( "hall_get_moving_i_got_yo_0" );  //Get moving, I got you!

}



//*****************************************************************************
// EVENT 11: Bridge Battle
//*****************************************************************************

#namespace bridge_battle;


function bridge_battle_start()
{
	bridge_battle_precache();
	
	bridge_battle_heros_init();
	
	level thread bridge_battle_main();
}

// DO ALL PRECACHING HERE
function bridge_battle_precache()
{
}

function bridge_battle_heros_init()
{	
	level.ai_hyperion ai::set_ignoreall( false );
	level.ai_hyperion ai::set_ignoreme( false );
	level.ai_hyperion.goalradius = 16;
	level.ai_hyperion.allowpain = false;
	level.ai_hyperion colors::set_force_color( "p" );	
	
	level.ai_theia ai::set_ignoreall( true );
	level.ai_theia ai::set_ignoreme( true );
	level.ai_theia.goalradius = 16;
	level.ai_theia.allowpain = false;
	
	level.ai_khalil ai::set_ignoreall( true );
	level.ai_khalil ai::set_ignoreme( true );
	level.ai_khalil.goalradius = 16;
		
	level.ai_minister ai::set_ignoreall( true );
	level.ai_minister ai::set_ignoreme( true );		
	level.ai_minister.goalradius = 16;	
	
	level.ai_hendricks ai::set_ignoreall( false );
	level.ai_hendricks ai::set_ignoreme( false );
	level.ai_hendricks.goalradius = 16;
	level.ai_hendricks.allowpain = false;	
}

// Event Main Function
function bridge_battle_main()
{
	level thread activate_bridge_defenses();
		
	//set up spawned guys to move or not move as desired
	spawner::add_spawn_function_group( "bridge_defenders_no_move" , "script_noteworthy", &hangar::ai_think );
    spawner::add_spawn_function_group( "bridge_defenders" , "script_noteworthy", &hangar::ai_think_and_move );
    spawner::add_spawn_function_group( "bridge_defenders_initial" , "script_noteworthy", &hangar::ai_think_and_move );
	spawner::add_spawn_function_group( "bridge_defenders_no_move", "script_noteworthy", &bridge_accuracy );
    
	level thread hyperion_bridge_dialog();

    level.ai_hyperion thread hyperion_fights();

	level bridge_destruction_sequence();	
	
	level thread bridge_compromised_dialog();
	
	objectives::complete( "cp_level_prologue_bridge", level.bridge_marker );
	//set objective to follow hyperion
	//objectives::set( "cp_level_prologue_meet_theia", level.ai_hyperion ); trying out no follows
	

	
	//This section handles the end of the skipto and gathers everyone at dark fight
	level building_hacking();
		
	skipto::objective_completed( "skipto_bridge_battle" );
}

function bridge_compromised_dialog()
{
	level.ai_hyperion dialog::say("mare_taylor_primary_exfi_0"); //Taylor, Primary exfil is compromised, moving on secondary.
}

function activate_bridge_defenses()
{
	//spawn in MGs by bridge
	spawner::simple_spawn_single( "bridge_turret_south" );
	spawner::simple_spawn_single( "bridge_turret_north" );
	
	//keep bridge defenders in their volume
	spawner::add_spawn_function_group( "bridge_last_line", "script_noteworthy", &bridge_goal_volume );
	
	level thread bridge_defense_timeout();
	
	level flag::wait_till( "activate_bridge_defenses1" ); //fires as player moves towards bridge
	
	//activate bridge spawners
	spawn_manager::enable( "sm_bridge_defenders2" );
	
	//bring in trucks
	level thread bridge_vehicles_troop_trucks("bridge_truck1", "sm_bridge_defenders_apc_right");
	wait 1.5; //let one truck get ahead
	level thread bridge_vehicles_troop_trucks("bridge_truck2", "sm_bridge_defenders_apc_left");
	
	level flag::wait_till( "activate_bridge_defenses2" ); //fires as player moves towards bridge
	
	//turn on bridge turrets
	e_turret = GetEnt ("bridge_turret_south_ai", "targetname");
	e_turret turret::enable(0);
	e_turret = GetEnt ("bridge_turret_north_ai", "targetname");
	e_turret turret::enable(0);

	//bring in jeeps
	level thread cp_prologue_util::spawn_and_drive_jeep_and_guy("bridge_jeep_right", "bridge_jeep_guy_right");
	level thread cp_prologue_util::spawn_and_drive_jeep_and_guy("bridge_jeep_left", "bridge_jeep_guy_left");
}

//turn on bridge defenses even if player doesn't move up
function bridge_defense_timeout()
{
	level flag::wait_till( "player_left_alley" );
	
	wait 15;
	
	level flag::set( "activate_bridge_defenses1" );

}

function bridge_destruction_sequence()
{
	level flag::wait_till( "bridge_destruction_sequence" );
	
	//wait an appropriate time
	wait 3; //pacing out vehicle spawns

	//bring in tons of vehicles
	
	wait 2; //pacing out vehicle spawns
	level.a_veh_bridge_reinforcements = [];
	level thread bridge_vehicles_background("bridge_truck_convoy1", 3, 2);
	level thread bridge_vehicles_background("bridge_truck_convoy2", 3, 2);
	wait 1;//pacing out vehicle spawns
	
	level.ai_hyperion thread dialog::say( "Reinforcement convoys coming over the bridge!" );

	wait 7; //pacing out vehicle spawns
	
	level.ai_hyperion thread dialog::say( "Shit! Too many! We don't have time for this, I'm blowing the charges!" );
	
	wait 1; //pacing out vehicle spawns
	
	//explosions at tower and in base
	a_structs = struct::get_array( "vtol_bridge_target", "targetname" );
	for( i=0; i<a_structs.size; i++ )
	{
		v_start_pos = a_structs[i].origin;
		
		v_target_pos = a_structs[i].origin;

		level.ai_hyperion thread apc_shared::fire_missile_at_struct( v_start_pos, v_target_pos );
		wait( 0.1 );
		foreach( e_player in level.players )
		{
			e_player PlayRumbleOnEntity( "tank_damage_heavy_mp" );
			Earthquake( 0.3, 1, e_player.origin, 128.0 );
		}
	}
	
	//boom - blow up everything
	struct = struct::get( "bridge_damage_struct", "targetname" );
	radiusDamage( struct.origin, 1200, 2000, 2000, undefined, "MOD_EXPLOSIVE" );
	
	struct = struct::get( "bridge_damage_struct_rear", "targetname" );
	radiusDamage( struct.origin, 2000, 2000, 2000, undefined, "MOD_EXPLOSIVE" );
	
	//remove the bridge TODO replace with fx anim, don't delete the currently falling vehicles
	m_bridge = getent( "bridge_destroy", "targetname");
	m_bridge Delete();
	array::run_all(level.a_veh_bridge_reinforcements, &Delete);

	//kill all enemies in case we missed some
		
	spawn_manager::kill( "sm_bridge_defenders2" );
	spawn_manager::kill( "sm_bridge_defenders_initial" );
	spawn_manager::kill( "sm_bridge_defenders_apc_left" );
	spawn_manager::kill( "sm_bridge_defenders_apc_right" );
	
	a_ais = GetAITeamArray( "axis", "axis" );
	foreach (ai in a_ais)
	{
		if(IsDefined(ai))
	   	{
			ai kill();
		}
	}
}

function bridge_vehicles_troop_trucks(truck, spawner)
{
	vh_truck1 = vehicle::simple_spawn_single( truck );
	vh_truck1 thread vehicle::go_path();	
	vh_truck1 waittill( "reached_end_node" );
	vh_truck1 DisconnectPaths();
	spawn_manager::enable( spawner );
}

function bridge_vehicles_background(spawner, amount, delay)
{
	for (i = 0; i < amount; i++)
	{
		veh = vehicle::simple_spawn_and_drive( spawner );
		level.a_veh_bridge_reinforcements[level.a_veh_bridge_reinforcements.size] = veh[0];
		wait delay;
	}
}

function bridge_accuracy()
{
	self endon( "death" );
	self.script_accuracy = 0.5; 
		
	level flag::wait_till( "bridge_destruction_sequence");
		
	self.script_accuracy = 1; 
}

function hyperion_fights()
{
	trigger::wait_till( "theia_shoot_plane");
	//teleport hyperion into place
	e_orig = GetEnt( "hyperion_teleport_point", "targetname" );
	self ForceTeleport( e_orig.origin, e_orig.angles, true );

	//send him to a cover position
	n_node = GetNode ("hyperion_bridge_start", "targetname");
	self SetGoal( n_node, true );
	self waittill( "goal" );
	
	//have him start fighting
	self ai::set_ignoreall( false );
	self ai::set_ignoreme( false );
	
}

function hyperion_bridge_dialog()
{
	level flag::wait_till("player_left_alley");
	level.ai_hyperion dialog::say( "mare_on_me_on_me_0" ); //On me, on me!
	
	level flag::wait_till("activate_bridge_defenses1");
	level.ai_hyperion dialog::say( "mare_exfil_is_across_the_0" );//ExFil is across the bridge up ahead.
	level.ai_hendricks dialog::say( "hend_they_ll_still_be_rig_0" );//They’ll still be right on our ass.
	level.ai_hyperion dialog::say( "mare_we_ve_set_charges_al_0" );//We’ve set charges all across the base to cover our exfil
	level.ai_hyperion dialog::say( "tayr_better_hustle_picku_0" );//Better hustle, pickup’s five out.
	
}

function building_hacking()
{		
	//put objective on building for player
	s_goto_int_building = struct::get( "obj_goto_int_building" , "targetname" );
	objectives::set( "cp_standard_breadcrumb", s_goto_int_building );
		
	trigger::use( "move_friendlies_to_darkroom_door");	//color chain allies to dark room
	
	//play the anims
	level scene::play( "cin_pro_12_01_darkbattle_vign_doorhack_theia_arrive" ); //this is on a do reach
	level thread hacking_dialog();
	level thread scene::play( "cin_pro_12_01_darkbattle_vign_doorhack_theia_hack" );
	
	//wait til partway through the hack
	level waittill( "comm_building_hacked" );
	
	level.int_building_blocker = GetEnt( "intelligence_building_entrance_blocker", "targetname" );
	//level.int_building_blocker NotSolid();
	level.int_building_blocker movez(-300, .05);
	
	//open the front doors
	door_l = GetEnt( "intelstation_entry_door_l", "targetname" );//TODO: play a sound here
	door_r = GetEnt( "intelstation_entry_door_r", "targetname" );
	
	v_move = ( 54, 0, 0 );
	move_time = .5;
	v_door_destination = (door_l.origin + v_move );
	door_l MoveTo( v_door_destination, move_time );
	v_door_destination = (door_r.origin - v_move );
	door_r MoveTo( v_door_destination, move_time );
	
	wait 1; 
	
	trigger::use( "move_friendlies_to_darkroom");
	
	volume = GetEnt( "allies_dark_battle_entry_gether", "targetname" );
	
	//wait for hyperion + minister + khalil
	while( 1 )
	{
		if( level.ai_hyperion IsTouching( volume ) && level.ai_minister IsTouching( volume ) && level.ai_khalil IsTouching( volume ) )
		{ 
			break;
		}
		
		wait 0.05;
	}
	
	//wait for player TODO: wait for all players to be in here then close the doors.
	level trigger::wait_till("trig_all_players_in_int_builing");
	level.int_building_blocker Solid();
	
	//close doors
	v_door_destination = (door_l.origin - v_move );
	door_l MoveTo( v_door_destination, move_time );
	v_door_destination = (door_r.origin + v_move );
	door_r MoveTo( v_door_destination, move_time );
	
	
	objectives::complete( "cp_standard_breadcrumb", s_goto_int_building );
	
}

function bridge_goal_volume()
{
	v_goal = GetEnt( "v_bridge_defense", "targetname");
	self SetGoalVolume(v_goal);	
}

function hacking_dialog()
{
	level.ai_hyperion dialog::say( "hall_heads_up_we_have_m_0" );//Heads up - we have multiple hostiles inside the comms room.
	level.ai_hyperion dialog::say( "mare_roger_that_accessin_0" );//Roger that. Accessing building’s electrical systems.
}


//*****************************************************************************
// EVENT 12: Dark Battle
//*****************************************************************************

#namespace dark_battle;


function dark_battle_start()
{
	dark_battle_precache();
	
	dark_battle_heros_init();
	
	//if this is a skipto
	if( !IsDefined(level.ai_hendricks) )
	{
		//objectives::set( "cp_level_prologue_meet_theia", level.ai_hyperion );
	}
	
	level thread dark_battle_main();
}

// DO ALL PRECACHING HERE
function dark_battle_precache()
{
	level flag::init( "player_spoted" );	
	level flag::init( "enemy_alerted" );
}

function dark_battle_heros_init()
{			
	level.ai_khalil ai::set_ignoreall( true );
	level.ai_khalil ai::set_ignoreme( true );
	level.ai_khalil.goalradius = 16;
	
	level.ai_hyperion ai::set_ignoreall( true );
	level.ai_hyperion ai::set_ignoreme( true );
	level.ai_hyperion.goalradius = 16;
	level.ai_hyperion.allowpain = false;
	level.ai_hyperion colors::set_force_color( "p" );
		
	level.ai_minister ai::set_ignoreall( true );
	level.ai_minister ai::set_ignoreme( true );		
	level.ai_minister.goalradius = 16;		
	
	level.ai_hendricks ai::set_ignoreall( true );
	level.ai_hendricks ai::set_ignoreme( true );
	level.ai_hendricks.goalradius = 16;
	level.ai_hendricks.allowpain = false;	
}

// Event Main Function
function dark_battle_main()
{	
	level flag::wait_till( "all_players_spawned" );	
	
	level thread vtol_guards_handler();//sets up guards at vtol section
	
	//initiate the hyperion cinematic stuff
	a_ai_array = GetSpawnerArray("dark_battle_cin1_guys", "script_aigroup");
	spawner::simple_spawn(a_ai_array);
	level thread scene::init( "cin_pro_12_01_darkbattle_vign_dive_kill_start"  );

	// function to check when player firing then AIs will stop and shoot at player depend on the distance
	level thread dark_battle_behavior_handler();
		
	//send hyperion up the stairs
	level thread scene::play( "cin_pro_12_01_darkbattle_vign_dive_kill_start" );
	
	trigger::use( "dark_battle_upstairs", "targetname" );
	
	//Start spawning in enemies below
	spawn_manager::enable( "sm_darkroom_spawner" );
	
	level.ai_hyperion dialog::say( "I'm going to send you some of my Tac Mode Data." );
	
	//turn on tac mode
	array::thread_all(level.players, &oed::set_player_tmode, true);
	
	level.ai_hendricks dialog::say( "Hostiles below, spreading out." );
		
	wait .5;
	
	level.ai_hyperion dialog::say( "A gunfight here would take too long - I'm going to kill the lights and hack their night vision. Move in when I do." );
	
	wait .5;
	//kill the lights
	level util::set_lighting_state(2);
	level.ai_hyperion thread dialog::say( "thea_disabling_the_lights_0" );

	wait 2;//wait for player to notice the darkness
	
	//play confused animations on all enemies
	level notify ("lights_out");
	
	//probably want to have this play on the individual dudes once we get more dialog strings
	level thread dark_room_confusion_dialog();
	
	//activate night vision
	array::thread_all(level.players, &oed::set_player_ev, true);
	
	//open upstairs door
	door_l = GetEnt( "intelstation_balcony_door_l", "targetname" );//TODO: play a sound here
	door_r = GetEnt( "intelstation_balcony_door_r", "targetname" );
	
	v_move = ( 54, 0, 0 );
	move_time = .5;
	v_door_destination = (door_l.origin + v_move );
	door_l MoveTo( v_door_destination, move_time );
	v_door_destination = (door_r.origin - v_move );
	door_r MoveTo( v_door_destination, move_time );
	
	//hyperion jumps down, goes into cover, and starts shooting
	level.ai_hyperion thread hyperion_movement();

		
	level flag::wait_till( "trig_allies_fire" );	//flag set as player moves down stairs
	wait 2;

	//have allies start shooting
	level.ai_hendricks ai::set_ignoreall( false );
	
	//wait until everyone is dead
	spawner::waittill_ai_group_ai_count( "aig_darkroom", 0 ); 

	level thread dark_room_clear_dialog();
	
	//open the downstairs doors for minister/khalil
	door_l = GetEnt( "intelstation_bottom_door_l", "targetname" );//TODO: play a sound here
	door_r = GetEnt( "intelstation_bottom_door_r", "targetname" );
	
	v_move = ( 54, 0, 0 );
	move_time = .5;
	v_door_destination = (door_l.origin + v_move );
	door_l MoveTo( v_door_destination, move_time );
	v_door_destination = (door_r.origin - v_move );
	door_r MoveTo( v_door_destination, move_time );
	
	door_l waittill("movedone");
	
	//TODO: put a nag here for hendricks to tell you to clear out the room
	
	//color chain everyone to the back
	trigger::use( "t_dark_battle_allies_to_end", "targetname" );
	
	//wait until minister/khalil are in the room
	e_volume = getent( "dark_battle_exit_gather", "targetname" );
	a_allies = [];
	array::add(a_allies, level.ai_khalil);
	array::add(a_allies, level.ai_hyperion);
	array::add(a_allies, level.ai_hendricks);
	array::add(a_allies, level.ai_minister);
	array::wait_till_touching(a_allies, e_volume);	
		
	//TODO make this a be inside trigger. maybe like above
	level flag::wait_till( "dark_battle_end" );	//flag set as player gets to exit of darkroom

	// turn off the enhanced vision
	array::thread_all(level.players, &oed::set_player_ev, false);
	
	//and turn off tac mode TODO move this to after the tackle once we can have it only show taylor
	array::thread_all(level.players, &oed::set_player_tmode, false);
	
	
	//objectives::complete( "cp_level_prologue_meet_theia", level.ai_hyperion ); trying out no follows		
	
	skipto::objective_completed( "skipto_dark_battle" );

}

function hyperion_movement()
{
	//this puts hyperion in position
	level scene::play( "cin_pro_12_01_darkbattle_vign_dive_kill_finish" );
	
	node = GetNode( "hyperion_dark_battle_cin_end", "targetname" );
	level.ai_hyperion SetGoal( node, true );
	
	level.ai_hyperion ai::set_ignoreall( false );
}

function dark_room_clear_dialog()
{
	level.ai_hyperion dialog::say( "mare_clear_0" );
}

function dark_room_confusion_dialog()
{
	level.ai_hyperion dialog::say( "nrcs_where_are_they_does_0" );	
}

function dark_battle_behavior_handler()
{
	foreach (player in level.players)
	{
		//set up a function to watch for each player firing
		player thread dark_battle_player_firing_check();
	}
	level.ai_hyperion thread dark_battle_player_firing_check();
	level.ai_hendricks thread dark_battle_player_firing_check();
	
	//set up spawn and damage callback functions on AIs
	level.callbackActorDamage = &hangarActorDamage;//not sure we need this for the design
	spawner::add_spawn_function_group( "darkroom_spawner" , "targetname", &dark_battle_spawner_init );
}

//self is the ai
function dark_battle_spawner_init()
{
	self endon( "dark_battle_end" );
	self endon( "death" );
	self.firing_at_something = false;
	
	//not sure this is going to be appreciated or add much
	//self thread dark_battle_AI_firing_check();
	
	self ai::set_behavior_attribute( "cqb", true );
	self.ignoreall = true;
	self.goalradius = 16;
	
	level waittill("lights_out");
	choice = RandomIntRange(1, 4);
	switch(choice)
	{	
		case 1:		
			str_anim = "cin_gen_vign_confusion_01";
		break;
		case 2:		
			str_anim = "cin_gen_vign_confusion_02";
		break;

		default:
		case 3:		
			str_anim = "cin_gen_vign_confusion_03";
		break;		
	}
	
	delay = RandomFloatRange(0.1, 0.5);
	wait delay; //let's not sync these anims up
	
	self thread scene::play(str_anim, self);
}

function dark_battle_player_firing_check()
{
	//self here is a player
	self endon( "dark_battle_end" );
	self endon( "death" );
	//constantly watch for the player firing
	while (1)
	{
		//wait til this fires
		self waittill( "weapon_fired" );
		self thread dark_battle_shots_fired();
		//wait a bit so they don't keep getting the same order
		wait 3;
	}
}

function dark_battle_AI_firing_check()
{
	//self here is an ai
	self endon( "death" );
	//constantly watch for the ai firing
	while (1)
	{
		//wait til this fires
		self waittill( "about_to_fire" ); 
		//self waittill( "shoot" );
		self thread dark_battle_shots_fired(true);
		wait 3;
	}
}

function dark_battle_shots_fired(HighPriority = false)
{
	//self here is player or AI - the shooter
	self endon( "death" );
	self endon( "dark_battle_end" );
	a_enemies = GetEntArray("darkroom_spawner_ai", "targetname");
	foreach (cur_enemy in a_enemies)
	{
		//once notified by a player firing, check to see if I have LOS on the target
		if( IsAlive(cur_enemy) && cur_enemy CanSee( self ) )
		{
			//check to see if I don't have a target
			if (cur_enemy.firing_at_something == false)
			{
				//shoot at targets's location
				cur_enemy thread fire_at_location(self);
			}
		}
	}
}

function fire_at_location(target, duration = 5, duration_variation = 2.5, min_height_offset = 0, max_height_offset = 0) //self is AI here, target is an ent
{
	self endon("death");
	//create an entity at the targets location
	self.firing_at_something = true;
	if (min_height_offset != max_height_offset)
	{
		height_offset = RandomIntRange(min_height_offset, max_height_offset);
	}
	else
	{
		height_offset = 0;
	}
	//TODO: Assert for this
	if (duration_variation <= 0)
	{
		duration_variation = 0;
	}
	else
	{
		duration = RandomFloatRange(duration - duration_variation, duration + duration_variation);
	}

	ent_to_shoot = Spawn( "script_model", target.origin+(0, 0, height_offset+64));
	ent_to_shoot SetModel( "tag_origin" );
	ent_to_shoot.health = 1000;
	ent_to_shoot.takeDamage = false;
	self SetGoal( self.origin, true);
	self thread ai::shoot_at_target( "normal" , ent_to_shoot , undefined , duration );
	
	//thread off the removal of the target ent in case enemy dies before deleting it
	ent_to_shoot thread dark_battle_ai_delete_target(duration+1);
	
	wait (duration);
	self thread ai::stop_shoot_at_target();
	self.firing_at_something = false;
}

function dark_battle_ai_delete_target(duration)
{
	wait duration;
	self  Delete();
}

function hangarActorDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, timeOffset, boneIndex, modelIndex, surfaceType, vSurfaceNormal )
{
	self endon("death");
	if (self.targetname == "darkroom_spawner_ai")
	{
		//if the ai is shot by an ally - REVENGE
		if ((IsDefined(eInflictor.targetname) && eInflictor.targetname ==  "darkroom_spawner_ai"))// || eInflictor.classname == "player")
		{
			self thread fire_at_location(eInflictor, 5, 0);
		}
		//if an ai is shot by an enemy, but not already shooting at something
		else if (self.firing_at_something == false)
		{
			self thread fire_at_location(eInflictor, 5, 0);
		}
	}
		
	self FinishActorDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, timeOffset, boneIndex, surfaceType, vSurfaceNormal ); 
}

//not currently used, but might be if we don't get anims
function fire_random_direction(height_offset)
{
	self endon("death");
	//self is an AI here
	height_offset = 48 + height_offset;
	self.firing_at_something = true;
	distance = 64 + height_offset;
	for (i = 0; i < 3; i++)
	{
		//Make random value within 30-90 of his current value
		myAngles = self.angles;
		random_yaw = RandomFloatRange(myAngles[1]+30, myAngles[1]+90);
				
		//add random value to yaw
		new_angles = (0, random_yaw, 0);
		
		//turn it into a vector
		vector = AnglesToForward(new_angles);
		//get the point
		height_offset_vector = (0, 0, height_offset);
		end_point = self.origin + height_offset_vector + (vector * distance);
	
		//spawn a thing at that location
		ent_to_shoot = Spawn( "script_origin", end_point );
		ent_to_shoot.health = 1000;
		
		duration = 1.5;
		self SetGoal( self.origin, true);
		self ai::shoot_at_target( "normal" , ent_to_shoot , undefined , duration );
		wait duration;
		//delete the ent
		ent_to_shoot Delete();
	}
	self.firing_at_something = false;
}


function vtol_guards_handler()
{
	spawner::add_spawn_function_group( "vtol_tackle_guy" , "script_noteworthy", &cp_prologue_util::ai_idle_then_alert,"vtol_has_crashed" );
	spawn_manager::enable( "vtol_tackle_spwn_mgr2" );
}

//*****************************************************************************
// EVENT 13: Vtol Tackle
//**********************************************************s*******************

#namespace vtol_tackle;


function vtol_tackle_start()
{
	vtol_tackle_precache();
	
	vtol_tackle_hero_init();

	//spawner::add_spawn_function_group( "vtol_tackle_guy" , "script_noteworthy", &hangar::ai_think_and_move  );
	
	level thread vtol_tackle_main();
}

// DO ALL PRECACHING HERE
function vtol_tackle_precache()
{
	
}

function vtol_tackle_hero_init()
{		
	level.ai_hyperion ai::set_ignoreall( true );
	level.ai_hyperion ai::set_ignoreme( true );
	level.ai_hyperion.goalradius = 32;
	level.ai_hyperion.allowpain = false;
	
	level.ai_prometheus ai::set_ignoreall( true );
	level.ai_prometheus ai::set_ignoreme( true );
	level.ai_prometheus.goalradius = 16;
	level.ai_prometheus.allowpain = false;
	
	level.ai_hendricks ai::set_ignoreall( true );
	level.ai_hendricks ai::set_ignoreme( true );
	level.ai_hendricks.goalradius = 16;
	level.ai_hendricks.allowpain = false;	
	
	level.ai_khalil ai::set_ignoreall( true );
	level.ai_khalil ai::set_ignoreme( true );
	level.ai_khalil.goalradius = 16;
		
	level.ai_minister ai::set_ignoreall( true );
	level.ai_minister ai::set_ignoreme( true );		
	level.ai_minister.goalradius = 16;			
}

// Event Main Function
function vtol_tackle_main()
{
	level flag::wait_till( "all_players_spawned" );
		
	//vtol tackle scene
	level vtol_tackle_scene();
	
	//wait until it's done to spawn in the replacement AI duders
	level cp_prologue_util::spawn_coop_player_replacement( "skipto_vtol_tackle_ai" );

	if( isDefined( level.ai_ally_01 ) )
	{
		level.ai_ally_01 ai::set_ignoreall( false );
		level.ai_ally_01 ai::set_ignoreme( false );
		level.ai_ally_01 thread hangar::ai_teleport( "ally_01_vtol_tackle_node" );
		level.ai_ally_01.goalradius = 16;
		
	}
	if( isDefined( level.ai_ally_02 ) )
	{
		level.ai_ally_02 ai::set_ignoreall( false );
		level.ai_ally_02 ai::set_ignoreme( false );
		level.ai_ally_02 thread hangar::ai_teleport( "ally_02_vtol_tackle_node" );
		level.ai_ally_02.goalradius = 16;
	}
	if( isDefined( level.ai_ally_03 ) )
	{
		level.ai_ally_03 ai::set_ignoreall( false );
		level.ai_ally_03 ai::set_ignoreme( false );
		level.ai_ally_03 thread hangar::ai_teleport( "ally_03_vtol_tackle_node" );
		level.ai_ally_03.goalradius = 16;
	}

	//kick off combat
	spawn_manager::enable( "vtol_tackle_spwn_mgr_door" );	
	
	// open the exit door
	door_l = GetEnt( "intelstation_exit_door_l", "targetname" );//TODO: play a sound here
	door_r = GetEnt( "intelstation_exit_door_r", "targetname" );
	
	v_move = ( 54, 0, 0 );
	move_time = .5;
	v_door_destination = (door_l.origin + v_move );
	door_l MoveTo( v_door_destination, move_time );
	v_door_destination = (door_r.origin - v_move );
	door_r MoveTo( v_door_destination, move_time );

	level.ai_hyperion ai::set_ignoreall( false );
	level.ai_hyperion ai::set_ignoreme( false );
	node = GetNode( "theia_vtol_tackle_node", "targetname" );
	level.ai_hyperion SetGoal( node, true );
	
	//turn off colors for pallas since he had orange before
	if (IsDefined(level.ai_pallas))
	{
		level.ai_pallas colors::disable();
	}
	level.ai_prometheus colors::set_force_color( "o" );
	
	level.ai_hendricks thread hendricks_vtol_tackle_path();
	
	level thread hendricks_vtol_snark();
	
	level flag::wait_till( "vtol_tackle_move_allies" );//fires as player moves up towards vtol wreckage
	thread dark_battle_cleanup();		
	spawn_manager::kill( "vtol_tackle_spwn_mgr", true );
	
	level thread enemies_killed_timeout(); //fires below trigger if all enemies die
	
	level flag::wait_till( "robot_reveal" ); //fires as player reaches robo alley
	
	objectives::set( "cp_level_prologue_find_vehicle" );
	
	skipto::objective_completed( "skipto_vtol_tackle" );
}


function vtol_tackle_scene()
{	
	vtol = vehicle::simple_spawn_single( "vtol" );
	//vtol.animname = "vtol";
	
	wait .5;
	
	level.ai_hyperion thread dialog::say( "Shit, they got a VTOL up - hold your fire!" );
	
	foreach (player in level.players)
	{
		array::run_all( level.players, &SetLowReady, true );
	}
	
	level thread vehicle_setup(); //send in the vehicles
	
	level thread scene::play("cin_pro_13_01_vtoltackle_vign_takedown_khalil");
	level thread scene::play("cin_pro_13_01_vtoltackle_vign_takedown_minister");
	level scene::play("cin_pro_13_01_vtoltackle_vign_takedown");
	
	level flag::set("vtol_has_crashed");
	
	foreach (player in level.players)
	{
		array::run_all( level.players, &SetLowReady, false );
	}
	
	//vtol vehicle::toggle_sounds( 0 );//shutting off tackle vtol sounds
	
	exploder::exploder( "fx_exploder_vtol_tackle" );
	

	
	level.ai_prometheus ai::set_ignoreall( false );
	level.ai_prometheus ai::set_ignoreme( false );	
	
	node = GetNode( "prometheus_vtol_tackle_node2", "targetname" );
	level.ai_prometheus thread ai::force_goal( node, 32 );	
}

// TODO: maybe should ask animator for notetrack
function vtol_fires()
{
	//self is vtol here
	//vehicle has just arrived
	self vehicle::get_off_path();
	self SetVehGoalPos(self.origin, true);
	//self vehicle::set_speed( 0, 1000 );
	
	level.ai_hyperion thread dialog::say( "VTOL Pilot: STEP AWAY FROM THE MINISTER, NOW!" );
	
	wait 1.5;
	
	//fire at target
	self turret::enable( 0, false );
	self turret::enable( 1, false );
	self turret::enable( 2, false );
	
	//get the target to shoot at
	e_targ = GetEnt("vtol_tackle_target", "targetname");
	e_targ.health = 100000;
	e_targ.takeDamage = false;
	
	//shoot the eff out of it
	self thread turret::shoot_at_target( e_targ, 20, undefined, 0 );
	self thread turret::shoot_at_target( e_targ, 20, undefined, 1 );
	self thread turret::shoot_at_target( e_targ, 20, undefined, 2 );

	wait .2;
	
	//move target horizontally so VTOL tracks it
	e_targ_move_to = GetEnt("vtol_tackle_target_move_to", "targetname");
	e_targ MoveTo( e_targ_move_to.origin, 5, 0, .25 );
	
	wait 2;
	
	level.ai_hyperion thread dialog::say( "Prometheus, wanna lend us a hand?" );
	
	e_targ waittill ("movedone");
	
	wait .2;
	e_targ.takeDamage = true;
	e_targ Delete();
	
	//shut it down, clay
	self turret::disable( 0 );
	self turret::disable( 1 );
	self turret::disable( 2 );	
}

function hendricks_vtol_snark()
{
	level.ai_hendricks dialog::say("hend_comes_easy_now_hu_0"); //Comes easy now -  huh, Taylor?
}

function vehicle_setup()
{
	wait 1; // tuning timing, replace with notetrack eventually
	vh_1 = vehicle::simple_spawn_single_and_drive( "vtol_vehicle" );
	
	level thread cp_prologue_util::arrive_and_spawn(vh_1, "vtol_tackle_spwn_mgr_veh");
	
	wait 8;
	level thread killed_by_vtol("vtol_vehicle");//uses same vehicle/spline for now, may not in the future
	wait 2; //space out vehicles
	level thread killed_by_vtol("vtol_vehicle");
}

function killed_by_vtol(str_veh)
{
	veh = vehicle::simple_spawn_single_and_drive( str_veh );
	level flag::wait_till("vtol_has_crashed");
	if (IsAlive(veh))
	{
		veh SetSpeed(0);
		veh dodamage( veh.health + 100, veh.origin );
	}
}

function hendricks_vtol_tackle_path()
{
	self ai::set_ignoreall( false );
	self ai::set_ignoreme( false);		
	node = GetNode( "hendricks_vtol_tackle_node2", "targetname" );
	self SetGoal( node, true );
	self.goalradius = 500;
}

function ai_setgoal( ai_node )
{
	node = GetNode( ai_node, "targetname" );
	self SetGoal( node, true );
}

function dark_battle_cleanup()
{
	a_ai_db_guys = util::get_ai_array( "dark_battle_guy", "targetname" );
		
	foreach( ai_guy in a_ai_db_guys )
	{
		if ( IsAlive( ai_guy ) )
		{
			ai_guy kill();
		}
	}
}

function enemies_killed_timeout()
{
	level spawner::waittill_ai_group_cleared("vtol_tackle_enemies");
	trigger::use("robot_reveal_trig");
}

#namespace prologue_util;

//Temp function to work around grenade spamming
function remove_grenades()
{
	self.grenadeammo = 0;
}
