#using scripts\codescripts\struct;

#using scripts\cp\_dialog;
#using scripts\cp\_laststand;
#using scripts\cp\_objectives;
#using scripts\cp\_skipto;
#using scripts\cp\_spawn_manager;
#using scripts\cp\_util;

#using scripts\shared\animation_shared;
#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\colors_shared;

#using scripts\cp\cp_mi_sing_blackstation;
#using scripts\cp\cp_mi_sing_blackstation_utility;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                              	   	                             	  	                                      

#using scripts\cp\cybercom\_cybercom_gadget_firefly;

#using scripts\shared\vehicle_shared;
#using scripts\shared\vehicleriders_shared;
#using scripts\shared\turret_shared;
#using scripts\shared\spawner_shared;

function police_station_main()
{
	level flag::init( "flag_kane_intro_complete" );
	level flag::init( "flag_enter_police_station" );
	level flag::init( "flag_police_station_hendricks_cqb_off" ); 
	level flag::init( "flag_lobby_ready_to_engage" );
	
	level.a_lobby_ai = [];
	
	level thread police_station_waypoints();
	level thread worklight_setup();
	level thread kane_intro_check();
	level thread spawn_management();
	level thread blackstation_utility::police_station_corpses();
	level thread cybercore_takedown();
	//level thread police_station_hendricks_movement(); //cut hendricks cqb for now 
	level thread cellblock_enemy_spawn();
	level thread lightning_police_station();
	level thread lightning_police_exit();
	
	//spawner::add_spawn_function_group( "police_station_exterior_group" , "targetname" , &lobby_ai_behavior );
	spawner::add_spawn_function_group( "police_station_group01" , "targetname" , &police_station_enemy_behavior );
	spawner::add_spawn_function_group( "police_groundfloor01" , "targetname" , &reinforcement_behavior );
	spawner::add_spawn_function_group( "police_upstairs01" , "targetname" , &reinforcement_behavior );
	spawner::add_spawn_function_group( "police_station_group03" , "targetname" , &reinforcement_behavior );
}

function police_station_waypoints()
{	
	objectives::set( "cp_standard_breadcrumb" , struct::get( "waypoint_police_station01" ) );
	level dialog::remote( "Kane: 54-I command hub is on the third floor. Expect heavy resistance." );
	
	level flag::wait_till( "flag_waypoint_police_station01" );
	objectives::complete( "cp_standard_breadcrumb" , struct::get( "waypoint_police_station01" ) );
	
	level flag::wait_till( "flag_enter_police_station" ); // wait to set inside objective until the cybercore intro is done.
	objectives::set( "cp_standard_breadcrumb" , struct::get( "waypoint_police_station02" ) );
	
	level flag::wait_till( "flag_waypoint_police_station02" );
	objectives::complete( "cp_standard_breadcrumb" , struct::get( "waypoint_police_station02" ) );
	objectives::set( "cp_standard_breadcrumb" , struct::get( "waypoint_police_station03" ) );
	
	level flag::wait_till( "flag_waypoint_police_station03" );
	objectives::complete( "cp_standard_breadcrumb" , struct::get( "waypoint_police_station03" ) );
	objectives::set( "cp_standard_breadcrumb" , struct::get( "waypoint_police_station04" ) );
	
	level flag::wait_till( "flag_waypoint_police_station04" );
	objectives::complete( "cp_standard_breadcrumb" , struct::get( "waypoint_police_station04" ) );	
}

function police_station_hendricks_movement()
{
	level flag::wait_till( "flag_police_station_hendricks_cqb" );
	
	level.ai_hendricks ai::set_behavior_attribute( "cqb", true );
	
	level flag::wait_till( "flag_police_station_hendricks_cqb_off" ); 
	
	level.ai_hendricks ai::set_behavior_attribute( "cqb", false );
}

function player_lobby_setup() //self = player
{
	trigger::wait_till( "trig_lobby_set_cqb", "targetname", self );
	
	blackstation_utility::set_low_ready_movement( true, self );
	
	level flag::wait_till( "flag_lobby_ready_to_engage" );
	
	blackstation_utility::set_low_ready_movement( false, self );	
}

function cybercore_takedown()
{
	level flag::wait_till( "flag_lobby_setup" );
	
	//array::thread_all( level.players, &player_lobby_setup ); //disable stealth approach for now 
	
	level.ai_hendricks ai::set_ignoreall( true );
	level.ai_hendricks ai::set_ignoreme( true );
	
	//spawn_manager::enable( "police_exterior_group_sm", true ); // spawn manger causes enemies to get alerted right away, don't use for now 
	spawner::simple_spawn( "police_station_exterior_group", &lobby_ai_behavior );

	level spawn_lobby_turrets();
	
	trigger::wait_till( "trig_police_station_lobby_in_position" ); // wait until you are in position
	
	if( !flag::get( "flag_lobby_engaged" ) ) // make sure they aren't alerted yet
	{
	   	level.ai_hendricks dialog::say( "Multiple hostiles. Marking target in your DNI." );
	
		is_turret_enemy_marked = false;
	
		for ( i = 0; i < level.players.size; i++ )
		{
			if( !is_turret_enemy_marked ) //Make sure the turret enemy gets marked 
			{
				foreach( ai_enemy in level.a_lobby_ai ) 
				{
					if ( IsAlive( ai_enemy ) && ai_enemy.script_noteworthy == "police_station_gunner_target_01" )
					{
						ai_enemy clientfield::set( "kill_target_keyline" , level.players[i] GetEntityNumber() + 1 ); //assigns each player 1 keylined target to shoot
						a_remove_enemy = [];
						array::add( a_remove_enemy, ai_enemy );
						level.a_lobby_ai = array::exclude( level.a_lobby_ai, a_remove_enemy );
						is_turret_enemy_marked = true;
					}
				}
			}
			else
			{
				if ( isdefined( level.a_lobby_ai[i] ) && level.a_lobby_ai[i].script_noteworthy != "police_station_gunner_target_02"  )
				{
					level.a_lobby_ai[i] clientfield::set( "kill_target_keyline" , level.players[i] GetEntityNumber() + 1 ); //assigns each player 1 keylined target to shoot
					ArrayRemoveIndex( level.a_lobby_ai, i, true );
				}
			}
		
		}
	
		level.ai_hendricks thread dialog::say( "All together now. On your shot." );
	
		level flag::set( "flag_lobby_ready_to_engage" );
	
		level flag::set( "flag_police_station_hendricks_cqb_off" );
	
		level flag::wait_till_timeout( 5, "flag_lobby_engaged" );// wait until the player starts shooting or it times out 

		level.ai_hendricks colors::disable();
	
		foreach ( ai_enemy in level.a_lobby_ai ) //Hendricks attacks the first turret enemy
		{
			if ( IsAlive( ai_enemy ) && ai_enemy.script_noteworthy == "police_station_gunner_target_02" )
				{
					level.ai_hendricks cybercom_gadget_firefly::spawn_firefly_swarm( true, ai_enemy, 1, 0 ); //Hendricks does the Fire Fly Swarm Attack
					break;
				}
		}
	
		wait 0.5; // wait a bit before hendricks starts firing
		
		level.ai_hendricks ai::set_ignoreall( false );
		level.ai_hendricks ai::set_ignoreme( false );
	
		if( level.players.size == 1 ) //since the spawn manager isn't working for this then have Hendricks help you kill these guys
		{
			foreach( ai_enemy in level.a_lobby_ai )
			{
				if ( IsAlive( ai_enemy ) )
				{
					level.ai_hendricks thread ai::shoot_at_target( "kill_within_time" , ai_enemy , "j_head" , 2 );
					MagicBullet( level.ai_hendricks.weapon, level.ai_hendricks GetTagOrigin( "tag_flash" ), ai_enemy GetTagOrigin( "tag_eye" ), level.ai_hendricks, ai_enemy );					
					ai_enemy waittill( "death" );
				}
			}
		}
	
	}
	else
	{
		level.ai_hendricks ai::set_ignoreall( false );
		level.ai_hendricks ai::set_ignoreme( false );
	}
	   
	spawner::waittill_ai_group_cleared( "lobby_enemies" ); // TODO add a time out on this as well 
	
	level flag::set( "flag_enter_police_station" );
	
	level.ai_hendricks SetGoal( GetNode( "hendricks_ambush_node", "targetname" ), true );
	level.ai_hendricks waittill( "goal" );
	
	level.ai_hendricks clearforcedgoal();
	level.ai_hendricks.goalradius = 200;
	level.ai_hendricks colors::enable();
	
	trigger::use( "trig_hendricks_move_into_police_station" , "targetname" ); // move hendricks into the police station
}

function lobby_patroller()
{
	self endon ( "death" );
	
	self ai::patrol( GetNode( "lobby_patrol_start_point", "targetname" ) );
			
	level flag::wait_till( "flag_lobby_engaged" );
			
	self SetGoalVolume( GetEnt( "lobby_defend_volume_01", "targetname" ) );
	
}

function spawn_lobby_turrets()
{
	for ( i = 1; i < 3; i++ )
	{
		vh_turret = vehicle::simple_spawn_single( "veh_turret_0" + i );
		vh_turret.fovcosine = 1;
		vh_turret turret::clear_target();
		vh_turret  turret::disable( 0 ); 
		vh_turret flag::init( "gunner_position_occupied" );
		ai_turret_gunner = spawner::simple_spawn_single( "turret_gunner_0" + i, &turret_gunner_think, vh_turret );
		vh_turret thread turret_think();
	}

}

function turret_gunner_think( vh_turret )  //self = turret gunner
{
	self ai::set_ignoreme( true );
	self ai::set_ignoreall( true );
	array::add( level.a_lobby_ai, self );
	self vehicle::get_in( vh_turret, "gunner1", true );
}

function turret_think() // self = turret
{
		vh_turret = self;
		
		vh_turret endon( "death" );
	
		// dont use burst fire on the turret for now
		const GUNNER_CHECK_TIME_MIN = 4;
		const GUNNER_CHECK_TIME_MAX = 5;
		
		// set burst fire parameters
		const FIRE_TIME_MIN = 1.0;
		const FIRE_TIME_MAX = 2.0;
		const FIRE_WAIT_MIN = 0.25;
		const FIRE_WAIT_MAX = 0.75;
		
		vh_turret turret::set_burst_parameters( FIRE_TIME_MIN, FIRE_TIME_MAX, FIRE_WAIT_MIN, FIRE_WAIT_MAX, 0 );
			
		ai_gunner = vh_turret vehicle::get_rider( "gunner1" );
			
		//wait to attack
		level flag::wait_till( "flag_lobby_engaged" );
			
		wait 2; // wait a few seconds to activate the turret once the fire fight begins 
			
		if ( isdefined( ai_gunner ) && IsAlive( ai_gunner )  )
		{			
			vh_turret turret::enable( 0, true );
				
			vh_turret.fovcosine = 0;
				
			vh_turret flag::set( "gunner_position_occupied" );
				
			ai_gunner waittill( "death" );  // TODO: add check on turret exit, if we ever want that
			
			vh_turret turret::disable( 0 );
			
			vh_turret flag::clear( "gunner_position_occupied" );
		}
		
}

function lobby_ai_behavior() //self = ai in lobby
{
	self endon( "death" );
	
	self thread proximity_detection_lobby();
	
	self.fovcosine = 1; //sets field of view to an angle of 0, effectively blind
	
	array::add( level.a_lobby_ai, self );
	
	if ( self.script_noteworthy == "lobby_patrol" )
	{
		self thread lobby_patroller();
	}
	
	self util::waittill_any( "enemy" , "damage" , "bulletwhizby" , "lobby_proximity" );

	level flag::set( "flag_lobby_engaged" ); 
	
	self.fovcosine = 0; //sets field of view back to the default 180 degrees
	self.goalradius = 200; //can move between nodes now
	
	//Set goal volume for each group
	if( self.script_noteworthy == "lobby_group_01"  )
	{
		self SetGoalVolume( GetEnt( "lobby_defend_volume_01", "targetname" ) );
	}
	else if( self.script_noteworthy == "lobby_group_02"  )
	{
		self SetGoalVolume( GetEnt( "lobby_defend_volume_02", "targetname" ) );
	}
}

function proximity_detection_lobby() //self = ai in first police station group. alerts ai if player gets too close.
{
	self endon( "death" );
		
	trigger::wait_till( "trig_lobby_proximity" , "targetname" );
	
	self notify( "lobby_proximity" );
}

function kane_intro_check() //makes sure the basement is clear of AI before starting Kane intro IGC
{
	trigger::wait_till( "trig_kane_intro" );
	
	foreach ( player in level.players )
	{
		if ( player laststand::player_is_in_laststand() )
		{
			//HACK This is a temp solution - need real support for what to do with players in last stand before an IGC
			player laststand::auto_revive( player );
		}
	}
	
	//HACK brute forcing cleanup of AI, because spawn manager cleared check above is not working reliably	
	a_hostile_ai = GetAITeamArray( "axis" );
	foreach( ai in a_hostile_ai )
	{
		ai Delete();
	}
	
	objectives::complete( "cp_standard_breadcrumb" , struct::get( "waypoint_police_station03" ) );
	skipto::objective_completed( "objective_police_station" );
}

function worklight_setup()
{	
	a_lights = GetEntArray( "script_worklight" , "targetname" );
	
	for ( i = 0; i < a_lights.size; i++ )
	{
		a_lights[i] fx::play( "worklight" , a_lights[i].origin , a_lights[i].angles , "fx_stop" , true , "tag_origin" );
		a_lights[i] fx::play( "worklight_rays" , a_lights[i].origin , a_lights[i].angles , "fx_stop" , true , "tag_origin" );
		
		a_lights[i] thread worklight_destruction();
	}
}

function worklight_destruction() //self = entity playing the light fx 
{
	//TODO setup an endon notify
	
	t_damage = GetEnt( self.target , "targetname" ); //get damage trigger
	
	if ( isdefined( t_damage ) )
	{
		t_damage trigger::wait_till(); //waiting for damage
	}
	
	level thread scene::play( t_damage.target , "targetname" ); //make the light fall down
	
	self notify ( "fx_stop" ); // turn the lights off 
}

function spawn_management() //Adjusts spawn manager counts based on player location(s).
{
	level flag::wait_till( "police_station_engaged" );
	
	spawn_manager::enable( "police_upstairs01_sm" , true );
	spawn_manager::enable( "police_groundfloor01_sm" , true );
	
	level trigger::wait_till( "trig_spawn_upstairs_intro" );
	
	if ( !flag::get( "flag_police_station_defend" ) ) //only spawn the upstairs enemies if you haven't crossed the mid point of the room 
	{
		spawner::simple_spawn( "police_upstairs02", &reinforcement_behavior ); //upstaris guys that run out of the interogation rooms
	}
}

function reinforcement_behavior() //self = ai spawned
{
	self endon( "death" );
	
	if ( IsDefined( self.targetname ) && self.targetname == "police_upstairs01" )
	{
		self SetGoalVolume( GetEnt( "police_station_upstairs_goal" , "targetname" ) );
	}
	else if ( IsDefined( self.targetname ) && self.targetname == "police_groundfloor01" )
	{
		self SetGoalVolume( GetEnt( "police_station_groundfloor_goal" , "targetname" ) );
	}
	
	level flag::wait_till( "flag_police_station_defend" );
	
	self SetGoalVolume( GetEnt( "police_station_defend_volume" , "targetname" ) );
}

function police_station_enemy_behavior() //self = ai in first police station group
{
	self endon( "death" );
	
	self thread proximity_detection();
	
	self.fovcosine = 1; //sets field of view to an angle of 0, effectively blind
	
	self util::waittill_any( "enemy" , "damage" , "bulletwhizby" , "police_station_proximity" );
	
	level flag::set( "police_station_engaged" );
	
	self.fovcosine = 0; //sets field of view back to the default 180 degrees
	
	self.goalradius = 600; //move freely
	
	level flag::wait_till( "flag_police_station_defend" );
	
	self SetGoalVolume( GetEnt( "police_station_defend_volume" , "targetname" ) );	
}

function proximity_detection() //self = ai in first police station group. alerts ai if player gets too close.
{
	self endon( "death" );
		
	trigger::wait_till( "trig_police_station_proximity" , "targetname" );
	
	self notify( "police_station_proximity" );
}

function cellblock_enemy_spawn()
{
	flag::wait_till( "flag_enter_cell_block" ); //wait until the player approaches
	
	e_trigger = trigger::wait_till( "trig_cellblock_ambush" ); //See who triggered this event
	
	if( e_trigger.who == level.ai_hendricks ) //check to see if hendricks hit the trigger first
	{
		sp_ambush_enemy = GetEnt( "cellblock_ambush_spawn_01", "targetname" );
		ai_ambush_enemy = sp_ambush_enemy spawner::spawn( true );
		ai_ambush_enemy cellblock_enemy_scene();
	}
	else // player must have hit the trigger
	{
		sp_ambush_enemy = GetEnt( "cellblock_ambush_spawn_02", "targetname" );
		ai_ambush_enemy = sp_ambush_enemy spawner::spawn( true );
	}
	
	//Move hendricks to next color trigger 
	trigger::use( "triger_hendricks_b7_cell_block_move", "targetname" );
}

function cellblock_enemy_scene() //self == cellblock ambush enemy
{
	self endon( "death" );
	
	level.ai_hendricks.ignoreall = true;
	self.ignoreall = true;
	
	level.ai_hendricks SetGoal( GetNode( "hendricks_cell_block_take_down_node", "targetname" ), true );
	self SetGoal( GetNode( "cellblock_ambush_node", "targetname" ), true );
		
	self waittill ( "goal" );
	level.ai_hendricks waittill ( "goal" );
	
	//n_distance_check = Distance( self.origin, level.ai_hendricks.origin ); cancel distance check for now 	
	self.animname = "patroller";
	level.ai_hendricks scene::play( "cin_blackstation_temp_stealth_kill" );
	level.ai_hendricks.ignoreall = false;
	level.ai_hendricks ClearForcedGoal();

}

// IGC KANE INTRO 
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function objective_kane_intro_init( str_objective, b_starting )
{
	if ( b_starting )
	{
		level thread blackstation_utility::police_station_corpses();
		
		level flag::init( "flag_kane_intro_complete" );
		
		blackstation_utility::init_hendricks( "objective_kane_intro" );
		
		level flag::wait_till( "all_players_spawned" );
	}
	
	level thread blackstation_utility::player_rain_intensity( "none" );
	level thread kane_intro_igc();
	
	level flag::wait_till( "flag_kane_intro_complete" );
	
	skipto::objective_completed( "objective_kane_intro" );
}

function objective_kane_intro_done( str_objective, b_starting, b_direct, player )
{	
	objectives::complete( "cp_level_blackstation_rendezvous" );
	objectives::set( "cp_level_blackstation_comm_relay" );
}

function kane_intro_igc() //TODO temp mockup of IGC
{
	util::screen_message_create( "IGC: Kane Intro" );
	level thread util::screen_fade_out( 1.5 );

	level.ai_hendricks SetGoal( GetNode( "kane_intro_hendricks_node" , "targetname") ); 
	
	a_e_orgs = GetEntArray( "kane_igc_positions" , "targetname" ); //this gets 4 script models where the player will endup standing after igc
	
	s_cam_start = struct::get( "kane_intro_camera" );
	
	foreach ( player in level.players )
	{	
		player enableinvulnerability();
		player FreezeControls( true );
	}
	
	level flag::wait_till( "screen_fade_out_end" );
	
	foreach ( player in level.players )
	{
		player.mdl_camera = util::spawn_model( "tag_origin", player.origin + (0,0,64) , s_cam_start.angles ); 
		
		player Hide();
		player HideViewModel();
		
		player.e_org = a_e_orgs[ player GetEntityNumber() ];
		
		player SetOrigin( player.e_org.origin );
		player SetPlayerAngles( player.e_org.angles );
		
		player CameraSetPosition( player.mdl_camera );
		player CameraActivate( true );
		
		player.mdl_camera MoveTo( s_cam_start.origin , 0.05 );
	}
	
	e_warlord = spawner::simple_spawn_single( "police_station_warlord" );
	e_warlord.allowdeath = false;
	e_warlord.takedamage = false;

	//Teleport Hendricks into location incase you run ahead of him
	nd_hendricks_start = GetNode( "kane_intro_hendricks_node", "targetname" );
	level.ai_hendricks.ignoreme = true;
	level.ai_hendricks.ignoreall = true;
	level.ai_hendricks ForceTeleport( nd_hendricks_start.origin, nd_hendricks_start.angles );
	level.ai_hendricks SetGoal( GetNode( "kane_intro_hendricks_node" , "targetname"), true ); 
	
	util::screen_fade_in( 0.25 );
	
	level.ai_hendricks.ignoreme = false;
	level.ai_hendricks.ignoreall = false;
	
	wait 2; //pause to let warlord attack a moment
	
	foreach ( player in level.players )
	{
		player.mdl_camera MoveX( -200 , 4 );
	}
	
	level.ai_kane = util::get_hero( "kane" );
	level.ai_kane.ignoreme = true;
	level.ai_kane.ignoreall = true;
	
	level.ai_kane util::waittill_any_timeout( 10 , "goal" , "force_goal" );
	
	level.ai_kane SetGoal( level.ai_kane.origin );

	//wait .25; //brief pause for effect
	
	level.ai_kane ai::shoot_at_target( "normal" , e_warlord , "j_elbow_bulge_ri" );
	e_warlord fx::play( "blood_headpop" , undefined, undefined, undefined, true, "j_elbow_bulge_ri", true );
	
	e_warlord.ignoreall = true;
	e_warlord ai::gun_remove();  // faking like he drops the gun
	
	level.ai_hendricks.ignoreall = true; //hendricks stops shooting
	
	//Remove this beat for now to make it quicker
	//wait 0.5; //let kane reload
	
	//level.ai_kane ai::shoot_at_target( "normal" , e_warlord , "j_knee_bulge_le" );
	//e_warlord fx::play( "blood_headpop" , undefined, undefined, undefined, true, "j_knee_bulge_le", true );
	
	level.ai_kane SetGoal( GetNode( "kane_intro_move" , "targetname" ) ); //move close to warlord
	
	//wait 0.5; //let kane reload
	
	level.ai_kane ai::shoot_at_target( "normal" , e_warlord , "j_head" );
	e_warlord fx::play( "blood_headpop" , undefined, undefined, undefined, true, "j_head", true );
	
	wait 0.25; //brief pause for effect
	
	e_warlord scene::play( "temp_warlord_fall_to_knees" , e_warlord ); //this kills the warlord

	wait 2.25; //let player process what just happened before returning control
	
	foreach ( player in level.players )
	{
		player.mdl_camera MoveTo( player.e_org.origin , 0.5 );
	}
	
	level util::screen_fade_in( 0.5 );
	
	util::screen_message_delete();
	
	foreach ( player in level.players )
	{
		player disableinvulnerability();
		player FreezeControls( false );
		player Show();
		player ShowViewModel();
		player Unlink();
		player.e_org Delete();
		player CameraActivate( false );
		
		player.mdl_camera Delete();
	}
	
	wait 0.5; //pause for effect
	
	level.ai_kane.ignoreme = false;
	level.ai_kane.ignoreall = false;
	level.ai_hendricks.ignoreall = false;

	level.ai_kane SetGoal( GetNode( "kane_intro_end" , "targetname" ) , true ); //send Kane to ndoe in next room
	
	level.ai_hendricks SetGoal( GetNode( "hendricks_node_kane_intro_end" , "targetname" ) , true ); //send Hendricks to ndoe in next room
	
	level flag::set( "flag_kane_intro_complete" );
	
	level.ai_kane dialog::say( "The 54i comms hub is in the next room. We can get their communication access codes from there." );
	
	level.ai_hendricks dialog::say( "Nice to meet you." );
	
	level.ai_kane dialog::say( "Storm took out the transmitter here. I can't send any signals." , 1 );
	level.ai_kane dialog::say( "There IS a communication relay station nearby. Hijack the terminal there and we can get the signal out. I'm pushing the location to your DNI." );
	
	level.ai_hendricks ClearForcedGoal();
	
	trigger::use( "trig_hendricks_comm_b0" , "targetname" ); //sends hendricks to next color 
	
	level flag::set( "flag_intro_dialog_ended" ); //enable exit color trigger
}

function camera_movement( v_loc ) //self = player.mdl_camera, a tag origin model linked to the player and also attached to the camera
{
	self MoveTo( v_loc , 1 );
	
	self waittill( "movedone" );
	
	level notify( "camera_move_done" );
}

function lightning_police_station()
{
	level flag::wait_till( "flag_lobby_setup" );
	
	level thread blackstation_utility::lightning_flashes( "lightning_looting", "subway_clear" );
}

function lightning_police_exit()
{
	level flag::wait_till( "flag_kane_intro_complete" );
	
	level thread blackstation_utility::lightning_flashes( "lightning_looting", "hendricks_at_window" );
}
