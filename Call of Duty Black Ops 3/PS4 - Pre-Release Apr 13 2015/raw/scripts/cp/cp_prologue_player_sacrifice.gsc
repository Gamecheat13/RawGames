#using scripts\codescripts\struct;

#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\cp\_dialog;
#using scripts\cp\_load;
#using scripts\cp\_objectives;
#using scripts\cp\_util;

#using scripts\cp\cp_mi_eth_prologue_fx;
#using scripts\cp\cp_mi_eth_prologue_sound;
#using scripts\cp\cp_prologue_util;
#using scripts\cp\cp_prologue_hangars;

#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\turret_shared;


#using scripts\cp\_skipto;
#using scripts\cp\cp_mi_eth_prologue;
#using scripts\cp\_spawn_manager;

#using scripts\cp\cp_prologue_robot_reveal;
#using scripts\cp\cp_prologue_apc;

//*****************************************************************************
//*****************************************************************************


	
#precache( "material", "t7_hud_minimap_beacon_key" );
#precache( "material", "t7_hud_waypoints_beacon" );

#precache( "objective", "cp_level_prologue_protect_minister" );
#precache( "objective", "cp_level_prologue_goto_skyhook" );
#precache( "objective", "cp_level_prologue_goto_skyhook_apc" );
#precache( "objective", "cp_level_prologue_escape" );

#precache( "string", "CP_MI_ETH_PROLOGUE_MINISTER_DIED" );
#precache( "string", "CP_MI_ETH_PROLOGUE_PLAYER_POD_PROMPT" );



#precache( "fx", "explosions/fx_exp_generic_lg" );


//*****************************************************************************
//*****************************************************************************
// EVENT 17: robot defend
//*****************************************************************************
//*****************************************************************************

#namespace robot_defend;

// NOTE: When progressing, players are left inside the vehicle
//			- using skipto they are outside the vehicle

// DO ALL PRECACHING HERE
function robot_defend_precache()
{
	level flag::init( "minister_killed_fail" );
	level flag::init( "squad_to_pod" );
	level flag::init( "hendricks_at_pod" );
	level flag::init( "tower_hit" );
	level flag::init( "initial_defenders_dead" );
	level flag::init( "start_defend_countdown" );
}

//*****************************************************************************
//*****************************************************************************
// Event Main Function
//*****************************************************************************
//*****************************************************************************
function robot_defend_main()
{
	robot_defend_precache();	
	setup_defend_spawn_funcs();
	
	level cp_prologue_util::spawn_coop_player_replacement( "skipto_robot_defend_ai" );
		
	level flag::wait_till( "all_players_spawned" );
	
	//Kick player out of APC first
	level thread apc_shared::kick_players_out_of_apc();
	
	//level thread scene::play("cin_pro_17_01_robotdefend_vign_groupmove_apc_exit");
	level thread scene::play("cin_pro_17_01_robotdefend_vign_apc_exit");
	
	//teleport players into place
	a_tp_spots = GetEntArray("robot_defend_player_start", "targetname");
	for (i = 0; i < level.players.size; i++)
    {
		level.players[i] ShellShock( "default", 5 );	
		v_pos = a_tp_spots[i].origin;
		v_start_angles = a_tp_spots[i].angles;
		//level.players[i] SetOrigin( v_pos );
		//level.players[i] SetPlayerAngles( v_start_angles );
	    level.players[i] FreezeControls( true );
	}
	
	//hide the use trigger
	trig_use_skyhook_player = GetEnt( "trig_use_skyhook_player", "targetname" );
	trig_use_skyhook_player TriggerEnable(false);

	//spawn in initial jeeps and enemies
	level thread spawn_handler_main();	
	
	//level.apc DisconnectPaths();
		
	objectives::set( "cp_level_prologue_protect_minister" );
	
	
	//pod standalone loop
	//level thread scene::init( "cin_pro_17_01_robotdefend_vign_moveout_pod" );
	level thread pod_handler();
	
	// Setup the background effects
	level thread background_effects();	

	// Send the team to the sky hook
	level thread allied_ai_movements();		
	
	// fxanim bridge
	level thread blowup_bridge();

	level waittill ("vtol_hooked_up");
	
	// End event
	skipto::objective_completed( "skipto_robot_defend" );
}



function spawn_handler_main()
{
	spawner::add_spawn_function_group( "aig_defend_initial", "script_aigroup", &ai_hold_position );
	spawner::add_spawn_function_group( "pod_attack_robots", "script_noteworthy", &robot_think_and_attack );
	spawner::add_spawn_function_group( "aig_defend_initial", "script_aigroup", &prologue_util::remove_grenades );
	spawner::add_spawn_function_group( "robo_defend_humans", "script_noteworthy", &prologue_util::remove_grenades );
	
	vh_apc_1 = vehicle::simple_spawn_single( "defend_APC_1" );
	vh_apc_2 = vehicle::simple_spawn_single( "defend_APC_2" );
	
	//set up damage callback on vehicle here to make it invincible
	vh_apc_1.overrideVehicleDamage = &callback_jeep_damage;
	vh_apc_2.overrideVehicleDamage = &callback_jeep_damage;
	
	vh_apc_1 thread vehicle::go_path();	
	vh_apc_2 thread vehicle::go_path();
	
	level thread cp_prologue_util::arrive_and_spawn(vh_apc_1, "sm_defend_apc_1");
	level thread cp_prologue_util::arrive_and_spawn(vh_apc_2, "sm_defend_apc_2");
	
	//wait til most guys are dead
	spawn_manager::wait_till_ai_remaining("sm_defend_apc_1", 1);
	spawn_manager::wait_till_ai_remaining("sm_defend_apc_2", 1);
	
	level flag::set( "initial_defenders_dead" );
	
	spawn_manager::enable( "sm_pod_mooks");
	
	wait 3;
	
	a_remaining_guys = spawner::get_ai_group_ai( "aig_defend_initial" );
	
	foreach( ai in a_remaining_guys )
	{	
		if ( IsAlive( ai ) )
			{
				ai kill();
			}
	}
	
	level.ai_hendricks thread dialog::say( "More enemies down there!" );
	
	//wait til they get blown up
	
	//wait til players are on their way to the pod
	//level flag::wait_till( "hendricks_at_pod" );
	spawner::waittill_ai_group_count( "aig_pod_mooks", 0);
	wait 3; // timing
	
	//spawn in vehicles 
	vh_apc_3 = vehicle::simple_spawn_single( "defend_APC_3" );
	vh_apc_3 thread vehicle::go_path();	
	//set up damage callback on vehicle here to make it invincible
	vh_apc_3.overrideVehicleDamage = &callback_jeep_damage;
	
	vh_apc_4 = vehicle::simple_spawn_single( "defend_APC_4" );
	vh_apc_4 thread vehicle::go_path();	
	//set up damage callback on vehicle here to make it invincible
	vh_apc_4.overrideVehicleDamage = &callback_jeep_damage;
	
	//wait til they arrived
	level thread cp_prologue_util::arrive_and_spawn(vh_apc_3, "sm_defend_apc_3");
	level thread cp_prologue_util::arrive_and_spawn(vh_apc_4, "sm_defend_apc_4");
	level thread cp_prologue_util::arrive_and_spawn(vh_apc_3, "sm_robot_defend_robo_apc_left");
	level thread cp_prologue_util::arrive_and_spawn(vh_apc_4, "sm_robot_defend_robo_apc_right");
	
	//activate tower guy, delay on the spawn manager
	spawn_manager::enable( "sm_robot_defend_tower");
	
	wait 3.5; // timing
	
	//send in backup jeeps
	level thread backup_vehicles_left();
	level thread backup_vehicles_right();
	
	level.ai_hendricks thread dialog::say( "They're coming from high and low!" );
	
	wait 3;//timing
	
	level.ai_hendricks thread dialog::say( "Grab a shotgun off the pod!" );
	
	//spawn in guys from out of sight
	spawn_manager::enable( "sm_robot_defend_tower_left");
	//spawn_manager::enable( "sm_robot_defend_robo_tower_left");
	spawn_manager::enable( "sm_robot_defend_tower_right");
	//spawn_manager::enable( "sm_robot_defend_robo_tower_right");	
	
	level flag::set( "start_defend_countdown" );
}


function allied_ai_movements()
{
	// Startup dialog
	level thread hendricks_start_message();	

	//this cinematic gets allies out of the jeep
	//level.apc thread scene::play( "cin_pro_17_01_robotdefend_vign_groupmove_apc_exit" );		
	
	//called on shutdown notetrack from hendricks anim
	//level waittill( "squad_exited_apc" );
	
	
	//keep players back until things are set up
	wait 5;
	
	//temp to unfreeze players in case they used skipto
	foreach ( player in level.players )
	{
		player FreezeControls( false );
	}
	
	level cp_prologue_util::spawn_coop_player_replacement( "skipto_robot_defend_ai" );
	
	if( isDefined( level.ai_ally_01 ) )
	{
		level.ai_ally_01.goalradius = 16;			
	}
	
	if( isDefined( level.ai_ally_02 ) )
	{	
		level.ai_ally_02.goalradius = 16;		
	}
	
	if( isDefined( level.ai_ally_03 ) )
	{
		level.ai_ally_03.goalradius = 16;		
	}	
	
	//color chain allies to cover near APC
	trigger::use( "trig_defend_position_allies1");
	
	level flag::wait_till( "initial_defenders_dead" );
	
	//wait til pod mooks get rekt
	spawner::waittill_ai_group_count( "aig_pod_mooks", 0);
	
	//color chain to move allies up to defend position
	trigger::use( "trig_defend_position_allies2");
	
	//wait til hendricks/minister/khalil in position
	level.ai_hendricks thread dialog::say( "Get to the pod!" );
	level.ai_hendricks waittill( "goal" );
	level flag::set( "hendricks_at_pod" );
	

	level.ai_hendricks thread dialog::say( "plyr_hold_them_back_the_0" );	
	
	/#
	IPrintLnBold( "HENDRICKS AT LOOP" );
	#/
}

function backup_vehicles_left()
{
	wait 5;
	veh = vehicle::simple_spawn_single( "backup_apc_left1" );
	veh thread vehicle::go_path();
	//set up damage callback on vehicle here to make it invincible
	veh.overrideVehicleDamage = &callback_jeep_damage;
	wait 4;
	veh = vehicle::simple_spawn_single( "backup_apc_left2" );
	veh thread vehicle::go_path();
	//set up damage callback on vehicle here to make it invincible
	veh.overrideVehicleDamage = &callback_jeep_damage;
}

function backup_vehicles_right()
{
	wait 5;
	veh = vehicle::simple_spawn_single( "backup_apc_right1" );
	veh thread vehicle::go_path();
	//set up damage callback on vehicle here to make it invincible
	veh.overrideVehicleDamage = &callback_jeep_damage;
	wait 3;
	veh = vehicle::simple_spawn_single( "backup_apc_right2" );
	veh thread vehicle::go_path();
	//set up damage callback on vehicle here to make it invincible
	veh.overrideVehicleDamage = &callback_jeep_damage;
	wait 3;
	veh = vehicle::simple_spawn_single( "backup_apc_right3" );
	veh thread vehicle::go_path();
	//set up damage callback on vehicle here to make it invincible
	veh.overrideVehicleDamage = &callback_jeep_damage;
}

function ai_hold_position()
{
	self.goalradius = 16;
	
	if( IsDefined( self.target ) )
	{
		node = GetNode( self.target, "targetname" );
		self SetGoal( node, true );
	}
}

function pod_handler()
{
	level.rescue_pod = GetEnt("rescue_pod", "targetname");
	
	brush_blocker = GetEnt("brush_pod", "targetname");
		
	v_up = ( 0, 0, 1 );
	lift_height = 4000;
	move_time = .1;
	v_lift_destination = (level.rescue_pod.origin + v_up * lift_height );
	level.rescue_pod MoveTo( v_lift_destination, move_time );
	//move blocker away
	brush_blocker MoveZ( -500, .05);
	
	
		
	//wait till all mooks are in the pod drop zone
	level flag::wait_till( "initial_defenders_dead" );
	
	wait 8;
	
	lift_height = -4000;
	move_time = 2;
	acceleration_time = 2;
	v_lift_destination = (level.rescue_pod.origin + v_up * lift_height );
	level.rescue_pod MoveTo( v_lift_destination, move_time, acceleration_time);
	//move blocker back
	brush_blocker MoveZ( 500, .05);
	
	
	//wait til move done
	level.rescue_pod waittill( "movedone" );
	
	v_start_pos = level.rescue_pod.origin;
	
	v_target_pos = level.rescue_pod.origin;

	//explode em
	a_ai = GetEntArray("aig_pod_mooks", "script_aigroup");

	foreach (ai in a_ai)
	{
		//ai StartRagdoll();
	}
	
	wait .1;

	//boom
	origin = level.rescue_pod.origin + ( 0, 0, 10 );
	const radius = 800;
	const min_damage = 2000;
	const max_damage = 2000;
	level.ai_hendricks radiusDamage( origin, radius, max_damage, min_damage, undefined, "MOD_EXPLOSIVE" );
	exploder::exploder("fx_exploder_pod_drop");
	PhysicsExplosionSphere( origin, radius, radius, 5, max_damage, min_damage );
	PlayRumbleOnPosition( "grenade_rumble", origin );
	Earthquake( 0.5, 0.5, origin, 512 );
	
	wait .1;
	
	foreach (ai in a_ai)
	{
		if ( IsAlive( ai ) )
		{
			ai Kill();
		}
	}
	
	level flag::wait_till( "start_defend_countdown" );
	
	wait 3;
	
	level thread pod_dialog1();

	level.rescue_pod.origin = level.rescue_pod.origin + (0, 0, -400);
		
	level thread scene::play("cin_pro_17_02_robotdefend_vign_hookup");
	
	//put hendricks into ai
	
	wait 22;
	
	level.ai_hendricks dialog::say( "Loading in Khalil" );
	
	wait 25;
	
	level notify("vtol_hooked_up");
	
	objectives::complete( "cp_level_prologue_protect_minister" );	
	
	level flag::wait_till( "start_tower_collapse" );
	

}

function pod_dialog1()
{
	level dialog::remote( "dops_drone_in_range_thir_0" ); // Drone in range. Thirty seconds.
	level.ai_hendricks dialog::say( "hend_there_s_our_ride_0" ); // There’s our ride... Cover me while I get the minister strapped in!
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
	
	//self ai::set_behavior_attribute( "move_mode", "marching" );
		
	node = getnode(self.target, "targetname");
	self thread robot_horde::follow_path( node );
	
	self waittill( "path_end_reached" );
	
	iprintlnbold( "Player fail to protect minister" );
	self ClearForcedGoal();
	self SetGoal( self.origin, true );
}

function robot_think_and_attack()
{
	self cp_prologue_util::set_robot_unarmed();
}


function tower_attackers_main()
{
//	ai_tower_attacker_robot = spawner::simple_spawn_single( "tower_attacker_robot" );
	
	s_start_pos = struct::get( "s_tower_shot_hit", "targetname" );
	s_end_pos = struct::get( s_start_pos.target, "targetname" );
	
	weapon = level.weapons["rpg"];
	e_bullet = MagicBullet( weapon, s_start_pos.origin, s_end_pos.origin );

	//temp wait
	wait 1.4;
	
	level flag::set( "tower_hit" );
	level thread scene::play( "p7_fxanim_cp_prologue_tower_vtol_collapse_initial_bundle" );	

}

function set_flag_on_ai_count_killed( str_ai_group, str_flag, n_ai_count)
{
	level flag::init( str_flag );
	spawner::waittill_ai_group_amount_killed( str_ai_group, n_ai_count );
	level flag::set( str_flag );
}

//workaround for vehicles crashing the game when they die
function callback_jeep_damage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, damageFromUnderneath, modelIndex, partName, vSurfaceNormal) 
{
	self.health = 100000;
	
	return( 1 );
}

//*****************************************************************************
//*****************************************************************************

function blowup_bridge()
{	
	//TODO play secondary bridge explosion
}

function monitor_intro_robot_squad()
{
	//wait until the player kills x amount of guys before turning on the spawn manager
	spawner::waittill_ai_group_amount_killed( "defend_guys_intro", 12 );
	
	level flag::set( "squad_to_pod" );
}

function setup_defend_spawn_funcs()
{
	//first wave guys - left.mid.right
	spawner::add_spawn_function_group( "defend_robots", "script_noteworthy", &setup_defend_robot );
	
	//spawn manager guys
	spawner::add_spawn_function_group( "defend_marchers_right", "targetname", &setup_defend_marcher );
	spawner::add_spawn_function_group( "defend_marchers_middle", "targetname", &setup_defend_marcher );
	
	//rpg tower guys
	spawner::add_spawn_function_group( "tower_attacker_robot", "targetname", &setup_tower_attacker_robot );
}

function setup_tower_attacker_robot()
{
	self endon( "death" );
	
	self thread util::magic_bullet_shield();
	
	self.ignoreall = true;
	self.ignoreme = true;	
	
	self waittill( "goal" );
	self.goalradius = 32;

	// Fire 5 rpgs at the ground near the player APC
	a_tower_vtol_targets = struct::get_array( "tower_vtol_targets", "targetname" );
	foreach( s_tower_target in a_tower_vtol_targets )
	{
		v_start_pos = self GetTagOrigin( "tag_flash" );
		v_target_pos = s_tower_target.origin;

		self thread fire_missile_at_tower( v_start_pos, v_target_pos );
		wait( 0.2 );
	}	
		
	level flag::wait_till( "tower_hit" );
		
	self.ignoreall = false;
	self.ignoreme = false;	
}

// self = rpg guy
function fire_missile_at_tower( v_start_pos, v_target_pos  )
{
	self endon( "death" );
	
	//weapon = GetWeapon( "rpg_cp" );
	weapon = level.weapons["rpg"];
	e_bullet = MagicBullet( weapon, v_start_pos, v_target_pos, self );
	e_bullet thread rgb_attack_tower( v_target_pos );
}

// self = weapon
function rgb_attack_tower( v_target_pos )
{
	self endon( "death" );

	while( 1 )
	{
		dist = distance( self.origin, v_target_pos );
		if( dist < 100 )
		{
			break;
		}
		wait( 0.05 );
	}

	PlayFX( "explosions/fx_exp_generic_lg", v_target_pos );
	PlaySoundAtPosition ( "wpn_rocket_explode" , self.origin );//missile exp sound

	level flag::set( "tower_hit" );
	
	level notify( "rpg_hits_floor" );
}

function setup_defend_marcher()
{
	self endon( "death" );

	//turn on glow eyes, wait until death then turns off
	self thread robot_horde::robot_eye_fx_on();	
	
	self.ignoreall = true;
	self.ignoreme = true;
	
	//TODO: i like this look, but they do not shoot while marching
	self ai::set_behavior_attribute( "move_mode", "marching" );	
	
	//send ai to his goal pos
	s_goalpos = struct::get( self.target, "targetname" );
	self thread ai::force_goal( s_goalpos.origin, 32 );
}

function setup_defend_robot()
{
	self endon( "death" );
	
	//turn on glow eyes, wait until death then turns off
	self thread robot_horde::robot_eye_fx_on();
	
}

//*****************************************************************************
//*****************************************************************************

function background_effects()
{
	exploder::exploder( "fx_exploder_background_exp_muz" );
}

//*****************************************************************************
//*****************************************************************************

//*****************************************************************************
//*****************************************************************************

function hendricks_start_message()
{
	
	// Hendricks tells players to defend
	wait( 1 );
	util::screen_message_create( "<The player is stunned after the crash>" );

	wait( 5 );
	util::screen_message_delete();
}


//*****************************************************************************
//*****************************************************************************
// EVENT 18: sky hook
//*****************************************************************************
//*****************************************************************************

#namespace sky_hook;

// DO ALL PRECACHING HERE
function sky_hook_precache()
{
	
}

// Event Main Function
function sky_hook_main()
{
	sky_hook_precache();
	
	level flag::wait_till( "all_players_spawned" );
	
	level cp_prologue_util::spawn_coop_player_replacement( "skipto_robot_defend_ai" );
	
	level thread pod_dialog2();
	level thread scene::play("cin_pro_17_01_robotdefend_vign_secured");
	
	// Create objective marker
	s_use_pos = struct::get( "s_objective_sky_hook", "targetname" );
	objectives::set( "cp_level_prologue_goto_skyhook", s_use_pos );

	trig_use_skyhook_player = GetEnt( "trig_use_skyhook_player", "targetname" );
	trig_use_skyhook_player TriggerEnable(true);
	trig_use_skyhook_player SetCursorHint( "HINT_NOICON" );
	//trig_use_skyhook_player UseTriggerRequireLookAt();
	trig_use_skyhook_player SetHintString( &"CP_MI_ETH_PROLOGUE_PLAYER_POD_PROMPT" );

	
	trig_use_skyhook_player waittill( "trigger", e_player );
	trig_use_skyhook_player Delete();
	
	// Turn off the objective marker
	objectives::complete( "cp_level_prologue_goto_skyhook" );
	
	//play end cinematic
	level flag::set( "start_tower_collapse" );
	
	//temp to remove the pod from previos anim
	//level thread scene::stop("cin_pro_17_02_robotdefend_vign_hookup");
	
	
	level thread scene::play("cin_pro_17_01_robotdefend_vign_moveout", e_player);
	level thread scene::play( "p7_fxanim_cp_prologue_tower_vtol_collapse_fall_bundle" );
	level thread scene::play( "cin_pro_18_01_skyhook_vign_impact" );
	
	level pod_dialog3();
	
	skipto::objective_completed( "skipto_sky_hook" );	
}

function pod_dialog2()
{
	level.ai_hendricks dialog::say( "hend_secure_get_your_ass_0" ); //Secure! Get your ass over here, NOW!
	level dialog::remote( "dops_drone_evac_ten_seco_0" ); //Drone EVAC, ten seconds.
	level.ai_hendricks dialog::say( "hend_move_move_move_0" ); //Move, move, move!!!
}

function pod_dialog3()
{
	level dialog::remote( "dops_exfil_in_progress_0" ); //Exfil in progress.
	level dialog::remote( "hend_wait_we_still_hav_0" ); //Wait! - We still have men on the ground.
	level dialog::remote( "dops_negative_airspace_i_0" ); //Negative. Airspace is compromised.
	level dialog::remote( "hend_no_no_no_no_fu_0" ); //No, no, no, no -- FUCK. Get to the APC! Get outta there!
	level dialog::remote( "tayr_inbound_two_minutes_0" ); //Inbound. Two minutes. 
	
}

function tower_fall_temp_anim()
{
	self freezecontrols( true );
	
	s_player_anchor_start = struct::get( "s_player_anchor_start", "targetname" );
	s_pos_1 = struct::get( s_player_anchor_start.target, "targetname" ); //look at tower
	s_pos_2 = struct::get( s_pos_1.target, "targetname" ); //look at vtol leaving
	s_pos_3 = struct::get( s_pos_2.target, "targetname" ); //look at path to truck

	e_player_anchor = util::spawn_model( "tag_origin", s_player_anchor_start.origin, s_player_anchor_start.angles );	
	self playerlinktodelta( e_player_anchor, "tag_origin", 1, 15, 15, 15, 15 );

	level.players[0] thread dialog::say( "Hendricks: Shit the TOWER!!!" );
	
	e_player_anchor MoveTo( s_pos_1.origin, 0.5 );
	e_player_anchor RotateTo( s_pos_1.angles, 0.5 );
	e_player_anchor waittill( "rotatedone" );
	
	wait .5;
	
	e_player_anchor MoveTo( s_pos_2.origin, 0.5 );
	e_player_anchor RotateTo( s_pos_2.angles, 0.5 );
	e_player_anchor waittill( "rotatedone" );

	self PlayRumbleOnEntity( "tank_damage_heavy_mp" );
	Earthquake( 0.65, 0.7, self.origin, 128.0 );	
	
	wait .5;
	
	e_player_anchor MoveTo( s_pos_3.origin, 0.5 );
	e_player_anchor RotateTo( s_pos_3.angles, 0.5 );
	e_player_anchor waittill( "rotatedone" );	
	
	self freezecontrols( false );
	self Unlink();
}

function monitor_tower_fall_timeout()
{
	level endon( "start_tower_collapse" );
	
	wait 10;
	
	IPrintLnBold( "Mission Failed" );
}

//*****************************************************************************
//*****************************************************************************

function trigger_skyhook_collapse_countdown()
{
	e_volume = GetEnt( "inf_skyhook_volume", "targetname" );

	min_time = 0.5;
	max_time = 7;

	start_time = gettime();

	trigger_collapse = 0;
	while( !trigger_collapse )
	{
		dt = ( gettime() - start_time ) / 1000;	

		if( dt > min_time )
		{
			// If players get close, trigger it
			a_players = GetPlayers();
			for( i=0; i<a_players.size; i++ )
			{
				e_player = a_players[i];

				// Is the player in the trigger volume?
				if( e_player IsTouching( e_volume) )
				{
					// Is the player looking at the tower?
					s_struct = struct::get( "s_objective_sky_hook", "targetname" );
					v_dir = VectorNormalize( s_struct.origin - e_player.origin );
					v_forward = anglestoforward( e_player.angles );
					dp = vectordot( v_dir, v_forward );
					if( dp >  0.0 )
					{
						trigger_collapse = 1;
						
						level flag::set( "start_tower_collapse" );
						break;
					}
				}
			}
		
			// Check for timeout
			if( dt > max_time)
			{
				level flag::set( "start_tower_collapse" );
				
				trigger_collapse = 1;
			}
		}

		wait( 0.05 );
	}
}



//*****************************************************************************
//*****************************************************************************

function reduce_robots_for_apc_escape_attempt()
{
	a_ai = GetAITeamArray( "axis" );
	if( IsDefined(a_ai) && (a_ai.size > 4) )
	{
		for( i=4; i<a_ai.size; i++ )
		{
			a_ai[i] delete();
		}
	}
}


//*****************************************************************************
// Robot Attacks tower with rockets - BLOCKING
//*****************************************************************************

function robot_rocket_attack_against_tower()
{
	// Send the robots to firing positions

	a_position = GetEntArray( "robots_with_rocket_fire_pos", "targetname" );
	a_target = GetEntArray( "robots_with_rocket_target", "targetname" );

	sp_array = GetEntArray( "sp_robots_with_rocket", "targetname" );
	for( i=0; i<sp_array.size; i++ )
	{
		e_ent = sp_array[i] spawner::spawn();
		e_ent thread rocket_attack_robot_update( a_position[i], a_target[i] );
	}
}

// self = ent
function rocket_attack_robot_update( v_pos, e_target )
{
	self endon( "death" );

	self.ignoreall = true;
	self.ignoreme = true;

	self.goalradius = 48;
	self SetGoal( v_pos );

	self waittill( "goal" );
		
	//e_target.health = 10000;
	self thread ai::shoot_at_target( "normal", e_target, undefined, 5, 10000 );

	wait( 5 );

	self notify( "stop_shoot_at_target" );
	self.goalradius = 2048;

	self.ignoreall = false;
	self.ignoreme = false;
}

