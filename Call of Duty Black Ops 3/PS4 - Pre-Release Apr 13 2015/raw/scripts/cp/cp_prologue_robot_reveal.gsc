
//
// Events 14 - 15
//
// prologue_robot_reveal.gsc
//

#using scripts\codescripts\struct;

#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\cp\_dialog;
#using scripts\cp\_load;
#using scripts\cp\_objectives;
#using scripts\cp\_skipto;
#using scripts\cp\_spawn_manager;
#using scripts\cp\_util;

#using scripts\cp\cp_mi_eth_prologue_fx;
#using scripts\cp\cp_mi_eth_prologue_sound;
#using scripts\cp\cp_mi_eth_prologue;
#using scripts\cp\cp_prologue_hangars;
#using scripts\cp\cp_prologue_util;

#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\trigger_shared;




#precache( "fx", "light/fx_glow_robot_control_gen_2_head" );
#precache( "objective", "cp_level_prologue_garage_door" );
#precache( "objective", "cp_level_prologue_defend_theia" );

//*****************************************************************************
// EVENT 14: Robot Horde
//*****************************************************************************

#namespace robot_horde;


function robot_horde_start()
{
	robot_horde_precache();
	
	robot_horde_heros_init();	
	
	//forces robots to walk to end of path
	spawner::add_spawn_function_group( "sp_initial_robots" , "targetname", &robot_think );
	spawner::add_spawn_function_group( "sp_initial_robots" , "targetname", &cp_prologue_util::fake_stealth_behavior, 128, "is_guy_alerted"   );
	spawner::add_spawn_function_group( "robot_aigroup" , "script_aigroup", &robot_think );
	spawner::add_spawn_function_group( "robot_aigroup" , "script_aigroup", &cp_prologue_util::fake_stealth_behavior, 128, "is_guy_alerted"   );
	
	level thread robot_horde_main();
}

// DO ALL PRECACHING HERE
function robot_horde_precache()
{
	//hide a colortrigger from previous section
	trig_color = GetEnt( "vtol_tackle_color", "targetname" );
	trig_color TriggerEnable(false);
}

function robot_horde_heros_init()
{		
	level.ai_theia ai::set_ignoreall( true );
	level.ai_theia ai::set_ignoreme( true );
	level.ai_theia.goalradius = 16;
	level.ai_theia.allowpain = false;
	
	level.ai_prometheus ai::set_ignoreall( true );
	level.ai_prometheus ai::set_ignoreme( true );
	level.ai_prometheus.goalradius = 16;
	level.ai_prometheus.allowpain = false;
	
	level.ai_hyperion ai::set_ignoreall( true );
	level.ai_hyperion ai::set_ignoreme( true );
	level.ai_hyperion.goalradius = 16;
	level.ai_hyperion.allowpain = false;
	
	level.ai_pallas ai::set_ignoreall( true );
	level.ai_pallas ai::set_ignoreme( true );
	level.ai_pallas.goalradius = 16;
	level.ai_pallas.allowpain = false;
	
	level.ai_hendricks ai::set_ignoreall( true );
	level.ai_hendricks ai::set_ignoreme( true );
	level.ai_hendricks.goalradius = 16;
	
	level.ai_khalil ai::set_ignoreall( true );
	level.ai_khalil ai::set_ignoreme( true );
	level.ai_khalil.goalradius = 16;
		
	level.ai_minister ai::set_ignoreall( true );
	level.ai_minister ai::set_ignoreme( true );		
	level.ai_minister.goalradius = 16;	
}

// Event Main Function
function robot_horde_main()
{		
	level flag::wait_till( "all_players_spawned" );	
	level cp_prologue_util::spawn_coop_player_replacement( "skipto_robot_horde_ai" );
	
	if( isDefined( level.ai_ally_01 ) )
	{
		level.ai_ally_01 ai::set_ignoreall( false );
		level.ai_ally_01 ai::set_ignoreme( false );
		level.ai_ally_01.goalradius = 16;			
	}
	
	if( isDefined( level.ai_ally_02 ) )
	{
		level.ai_ally_02 ai::set_ignoreall( false );
		level.ai_ally_02 ai::set_ignoreme( false );	
		level.ai_ally_02.goalradius = 16;		
	}
	
	if( isDefined( level.ai_ally_03 ) )
	{
		level.ai_ally_03 ai::set_ignoreall( false );
		level.ai_ally_03 ai::set_ignoreme( false );
		level.ai_ally_03.goalradius = 16;		
	}	
	
	//play initial cinematic setups
	level thread hend_min_khalil_handler();
	level thread cybersoldier_handler();
	level thread robot_setup_dialog();
	
	wait 3;
	
	//boss cyberman yelling out orders to everyone
	level.ai_prometheus thread dialog::say( "Theia, get the door. You four take the front. Hendricks, Khalil - watch our rear. We're on overwatch." );
		
	level flag::wait_till("player_in_alley"); //wait til players move up the alley
	
	//spawn initial couple robots
	level thread robot_eye_fx();
	spawn_manager::enable( "sm_initial_robots" );
	wait 1;

	level thread robot_intro_dialog();
		
	//have all characters fire on them
	a_allies = cp_prologue_util::get_ai_allies();
	a_allies[a_allies.size] = level.ai_theia;
	//a_allies[a_allies.size] = level.ai_prometheus;
	a_allies[a_allies.size] = level.ai_hendricks;
	a_allies[a_allies.size] = level.ai_khalil;
	a_allies[a_allies.size] = level.ai_pallas;
	a_allies[a_allies.size] = level.ai_hyperion;
	foreach (ally in a_allies)
	{
		ally ai::set_ignoreall( false );
		ally ai::set_ignoreme( true );
	}

	wait 5;//wait while player shoots at robots
	
	//show text "more incoming: GET US IN THERE"
	level.ai_hyperion dialog::say( "More incoming - GET THAT DOOR!" );
	
	//spawn rest of robots
	spawn_manager::enable( "sm_robot_horde1" );
	spawn_manager::enable( "sm_robot_horde2" );
	spawn_manager::enable( "sm_robot_horde3" );
	
	//removes no see clips onces robots move forward -TODO: not sure this is needed
	level thread remove_clips();

	wait 5; //timing wait
	
	level.ai_prometheus thread dialog::say( "It's almost open - hold them off!" );
	
	wait 7; //timing wait
	
	//wait til we want theia to open the door
	level.ai_prometheus thread dialog::say( "Everyone in, NOW!" );
	
	// Objective Set: player get to garage door
	objectives::complete( "cp_level_prologue_defend_theia", level.ai_prometheus );    
	level.garage_door = struct::get( "garage_door", "targetname" );
	objectives::set( "cp_level_prologue_garage_door", level.garage_door );
	
	// Scene: Khalil, Hendricks, and the minister will run inside, Theia will step inside and go into a wait idle  	
	level thread scene::play( "cin_pro_15_01_getinside_new_move2apc_minister_khalil_apc");
	level thread scene::play( "cin_pro_15_01_opendoor_vign_getinside_new_hendricks");
	
	//prometheus opens the doors
	level thread scene::play( "cin_pro_15_01_opendoor_vign_getinside_new_prometheus_doorhold"  );
	
	// move the allies inside;
	level thread move_allies_garage();
	
	//cyber guys jump into the robot horde
	level thread scene::play( "cin_pro_15_01_opendoor_vign_getinside_new_cybersoldiers" );
	//TODO: unroot them so they can be in melee or give them more targets?
	
	//wait til everyone is in the garage then play the door close anim
	level waittill("minister_inside_garage");
	garage_wait_for_players();
	
	// Objective complete: player get to garage door
	objectives::complete( "cp_level_prologue_garage_door", level.garage_door );	
		
	//block off backtrack path immediately
	e_lift_door = GetEnt( "apc_garage_collision", "targetname" );
	e_lift_door.origin = e_lift_door.origin + (0, 0, -140);
	
	// Scene: prometheus close the gate and jacks the APC - end section once this is complete
	level thread scene::play( "cin_pro_15_01_opendoor_vign_mount_new_prometheus_move2apc");
	

	level waittill("prometheus_at_apc");
	
	// make sure the gate close before kill the robots
	level thread cleanup_robots();
		
	skipto::objective_completed( "skipto_robot_horde" );
}


function hend_min_khalil_handler()
{
	level thread scene::play("cin_pro_14_01_robothorde_vign_dismantle_new_hendricks_start");	
	level thread scene::play("cin_pro_14_01_robothorde_vign_dismantle_new_khalil_start");	
	level thread scene::play("cin_pro_14_01_robothorde_vign_dismantle_new_minister_start");	
	
	//TODO: get real notetrack here
	level waittill("hendricks_idling");
	level waittill("khalil_idling");
	level waittill("minister_idling");
	wait 1;//TODO: remove when using correct notetrack
	
	trigger::use( "robot_defend_color_chain1", "targetname" );
	
	level thread scene::play("cin_pro_14_01_robothorde_vign_dismantle_new_hendricks_move2door");	
	level thread scene::play("cin_pro_14_01_robothorde_vign_dismantle_new_khalil_move2door");	
	level thread scene::play("cin_pro_14_01_robothorde_vign_dismantle_new_minister_move2door");
	
	wait 1; // wait a bit so the AI don't move in on top of the animated guys, but keep them behind the player
}

function cybersoldier_handler()
{
	level thread scene::play("cin_pro_14_01_robothorde_vign_dismantle_new_cybersoldiers");	
	level thread scene::play("cin_pro_14_01_robothorde_vign_dismantle_new_prometheus");	
	
	//wait til taylor is unlocking the garage
	level waittill("prometheus_hacking");
	objectives::set( "cp_level_prologue_defend_theia", level.ai_prometheus );
	

}

function robot_setup_dialog()
{
	level.ai_prometheus dialog::say("tayr_extract_is_the_satel_0"); // Extract is the Satellite Tower. We’ll commandeer a vehicle and get you to extraction.
	level.ai_hendricks dialog::say("hend_you_didn_t_answer_me_0"); // You didn’t answer me John.
	
}

function robot_intro_dialog()
{
	level.ai_hyperion dialog::say( "mare_contact_contact_0" ); // Contact -- CONTACT!
	wait 1;// pacing
	level.ai_pallas dialog::say( "diaz_incoming_bots_a_s_0" ); // Incoming bots! - A shit-ton of them!
}
	

function move_allies_garage()
{
	//wait til navmesh is created
	wait 1.5;
	
	if( isDefined( level.ai_ally_01 ) )
	{		
		node = GetNode( "ally01_garage_goal", "targetname" );
		level.ai_ally_01 ai::set_ignoreall(true);
		level.ai_ally_01 SetGoal( node, true );		
	}
	
	if( isDefined( level.ai_ally_02 ) )
	{
		node = GetNode( "ally02_garage_goal", "targetname" );
		level.ai_ally_02 ai::set_ignoreall(true);
		level.ai_ally_02 SetGoal( node, true );	
	}
	
	if( isDefined( level.ai_ally_03 ) )
	{
		node = GetNode( "ally03_garage_goal", "targetname" );
		level.ai_ally_03 ai::set_ignoreall(true);
		level.ai_ally_03 SetGoal( node, true );	
	}	
}

function garage_wait_for_players()
{
	e_volume = getent( "info_apc_garage_volume", "targetname" );
	a_allies = cp_prologue_util::get_ai_allies_and_players();
	
	array::wait_till_touching(a_allies, e_volume);
}

function set_cyber_soliders_goal( ent )
{
	level.ai_pallas SetGoal( level.ai_pallas.origin, true );
	level.ai_hyperion SetGoal( level.ai_hyperion.origin, true );
}

function remove_clips()
{
	level flag::wait_till( "cyber_soldiers_kill_robots" );	// flag set in radient trigger by robots
	
	clips = GetEntArray( "robot_clip", "targetname" );
	foreach( clip in clips)
	{
		clip delete();
	}
}


function incremental_robot_damage()
{
	//damages robots when they walk over the damage_triger
	self endon( "death" );
	
	trigger = GetEnt ("damage_trigger", "targetname");
	
	while ( !(self IsTouching( trigger )))
	{
		wait .1;
	}
	
	
	while ( self IsTouching( trigger ) && IsAlive(self) )
	{
		self dodamage(50, self.origin);
		wait .3;		
	}
	
	self waittill( "path_end_reached" );		
	self SetGoal( level.ai_minister, true );	
}

function play_phosphorus_fx()
{        
	exploder::exploder( "fx_exp_phosphorus_prologue" );	
	exploder::exploder( "fx_exploder_phosphorus_wall" );
	
	trigger::wait_till( "player_inside_garage");
	
	exploder::stop_exploder( "fx_exp_phosphorus_prologue" );	
	exploder::stop_exploder( "fx_exploder_phosphorus_wall" );
	exploder::stop_exploder( "fx_exploder_vtol_tackle" );
}


function cleanup_robots()	
{
	wait 1;	
	thread hangar::cleanup( "sm_robot_horde1", "robot_aigroup" );
	thread hangar::cleanup( "sm_robot_horde2", "robot_aigroup" );
	thread hangar::cleanup( "sm_robot_horde3", "robot_aigroup" );
	
}


function robot_think()
{
	self endon( "death" );
	
	self cp_prologue_util::set_robot_unarmed();
	
	//self ai::set_ignoreme( true );
	self ai::set_ignoreall( true );
	self.goalradius = 8;	
	self PushActors( true );
	self ai::disable_pain();
	
	//fictionally, the player's weapons are shitty against robots, so they are tougher
	self.health = self.health * 2;

	self waittill( "path_end_reached" );
	
	iprintlnbold( "Player fail to protect minister" );
	self ClearForcedGoal();
	self SetGoal( self.origin, true );
	self ai::set_ignoreall( false );
}

function robot_eye_fx()
{	
	trig = getent( "start_robot_eye", "targetname" );
	
	while ( true )
	{	
		//waits til robot crosses the trigger nearer to the player
		trig waittill( "trigger", ai_robot );
	
		if( isAI( ai_robot) && !( isdefined( ai_robot.eye_fx_on ) && ai_robot.eye_fx_on ) )
		{
			ai_robot.eye_fx_on = true;
					
			ai_robot thread robot_eye_fx_on();
		}
		
	}		
}

function robot_eye_fx_on()
{	
	self clientfield::set( "robot_eye_fx", 1 );
}

function follow_path( start_node )
{
	self endon( "death" );
	self endon( "path_end_reached" );

	wait 0.1;

	node = start_node;
	
	getfunc = undefined;
	gotofunc = undefined;
	
	
	//only nodes dont have classnames - ents do
	if( !isdefined( node.classname ) )
	{
		getfunc = &follow_path_get_node;
		gotofunc = &follow_path_set_node;
	}
	else
	{
		getfunc = &follow_path_get_ent;
		gotofunc = &follow_path_set_ent;
	}
	
	while( isdefined( node ) )	
	{
		if( isdefined( node.radius ) && node.radius != 0 )
			self.goalradius = node.radius;
		if( self.goalradius < 16 )
			self.goalradius = 16;
		if( isdefined( node.height ) && node.height != 0 )
			self.goalheight = node.height;

		self [[ gotofunc ]]( node );
		
		original_goalradius = self.goalradius;

		while(1)
		{
			self waittill( "goal" );
			if( distance( node.origin, self.origin ) < ( original_goalradius + 10 ) )
				break;
		}
		
		node notify( "trigger", self );


		if( !isdefined( node.target ) )
			break;

		node util::script_delay();

		node = [[ getfunc ]]( node.target, "targetname" );
		node = node[ randomint( node.size ) ];
	}


	self notify( "path_end_reached" );
}

function follow_path_get_node( name, type )
{
	return getnodearray( name, type );	
}

function follow_path_get_ent( name, type )
{
	return getentarray( name, type );	
}

function follow_path_set_node( node )
{
	self set_goal_node( node );
	self notify( "follow_path_new_goal" );
}

function follow_path_set_ent( ent )
{
	self set_goal_ent( ent );
	self notify( "follow_path_new_goal" );	
}

function set_goal_node( node )
{
	self.last_set_goalnode 	= node;
	self.last_set_goalpos 	= undefined;
	self.last_set_goalent 	= undefined;
	
	self setgoalnode( node );
}

function set_goal_ent( target )
{
	set_goal_pos( target.origin );
	self.last_set_goalent 	= target;
}

function set_goal_pos( origin )
{
	self.last_set_goalnode 	= undefined;
	self.last_set_goalpos 	= origin;
	self.last_set_goalent 	= undefined;
	
	self setgoalpos( origin );
}