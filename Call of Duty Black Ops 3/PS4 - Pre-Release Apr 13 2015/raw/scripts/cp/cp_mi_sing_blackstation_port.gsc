#using scripts\codescripts\struct;

#using scripts\cp\_dialog;
#using scripts\cp\_objectives;
#using scripts\cp\_skipto;
#using scripts\cp\_spawn_manager;
#using scripts\cp\_util;

#using scripts\cp\cybercom\_cybercom_gadget_concussive_wave;

#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\colors_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\turret_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\vehicleriders_shared;

#using scripts\cp\cp_mi_sing_blackstation_utility;

       
    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
   	     	                                                                                                                                                                                                                                                                                                                                                                                                                                                             	                                                                                                                	    	                                                                                                  
                                                                                                                                               	
           	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              	  	                                 	                 	    	                                      	      	      	       	                                                                   	          	  	                                                                               	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          	                                                                                                      	                                                                                                     	                                                                                                     	                                                                                                	     	                                                                                                                                                                                                                                                                                                                                                                                 	     	    	                                                                                                                                    	                      	              	  	               
        	                                                                                                                                                	                                                                                                                      	                                                                                     	                                                                                     	                                                               	                                                   	                                                                           	                                                                                 	                                       	                             	                                             	                                  	                                                                                 	                                                                                                                                                	      
                                                              	   	                             	  	                                      

#using scripts\shared\ai\systems\animation_state_machine_notetracks;
#using scripts\shared\ai\systems\animation_state_machine_utility;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\callbacks_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\system_shared;
#using scripts\cp\cybercom\_cybercom;
#using scripts\cp\cybercom\_cybercom_util;



#precache( "string", "CP_MI_SING_BLACKSTATION_USE_ANCHOR" );
#precache( "triggerstring", "CP_MI_SING_BLACKSTATION_BREACH" );
#precache( "triggerstring", "CP_MI_SING_BLACKSTATION_BREACH_STACK" );

function main()
{
	level thread blackstation_utility::pier_safe_zones();
	level thread wheelhouse_node_handler();
}

function anchor_intro( str_objective, b_starting )
{
	if ( b_starting )
	{
		blackstation_utility::init_hendricks( "objective_anchor_intro" );
		
		level thread blackstation_utility::constant_debris();
		
		objectives::set( "cp_level_blackstation_qzone" );
				
		trigger::wait_till( "anchor_intro_start" );
		
		wait 0.5;  //give Hendricks time to teleport
		
		trigger::use( "triggercolor_b8_hendricks_wall_climb" );
	}
	
	level thread blackstation_utility::player_rain_intensity( "med" );
	level thread debris_car_launch();
	level thread debris_toilet_launch();
	level thread blackstation_utility::random_debris();
	level thread blackstation_utility::debris_at_players();
	level thread blackstation_utility::debris_embedded_trigger();
	level thread tanker_movement();
	level thread lightning_port_assault();
		
	level dialog::remote( "We are detecting heavy winds ahead, use your anchoring system to stay grounded." );//Kane
	
	level thread hendricks_anchor_warning();
	level thread kane_missiles( false );
	
	t_intro_storm = GetEnt( "anchor_intro_wind", "targetname" );
	t_intro_storm trigger::wait_till();
	
	level thread anchor_tutorial();
	level thread blackstation_utility::setup_wind_storm( t_intro_storm );
	
	level flag::wait_till( "anchor_intro_done" );
	
	skipto::objective_completed( "objective_anchor_intro" );
}

function anchor_intro_done( str_objective, b_starting, b_direct, player )
{	
	objectives::complete( "cp_level_blackstation_qzone" );
	
	objectives::set( "cp_level_blackstation_secure_cargo" );
}

function port_assault( str_objective, b_starting )
{	
	spawner::add_spawn_function_group( "port_enemy", "script_noteworthy", &port_enemy_spawnfunc );
	vehicle::add_spawn_function( "port_assault_tech", &setup_port_technical );
	
	level thread blackstation_utility::water_manager();
	level thread port_assault_debrisfly();
	level thread port_assault_enemies();
	level thread port_assault_truck();
	level thread surge_debris_portstart();
	level thread surge_debris_powerplant();
	level thread surge_debris_restaurant();
				
	level clientfield::set( "pier_wave_init", 1 );
	
	if ( b_starting )
	{
		blackstation_utility::init_hendricks( "objective_port_assault" );
		
		trigger::use( "trigger_hendricks_anchor_done" );
		
		level thread tanker_movement();
				
		trigger::wait_till( "port_assault_start" );
		
		level thread flying_boat();
		level thread kane_missiles( true );
	}
	
	level.ai_hendricks.is_in_safety_zone = false;
		
	t_surge = GetEnt( "port_assault_low_surge", "targetname" );
	level thread blackstation_utility::setup_surge( t_surge );		
		
	trigger::use( "port_assault_start", "targetname", undefined, false );//Used for full progression
	
	trigger::wait_till( "surge_tutorial" );
	
	level flag::set( "end_surge_start" );
	
	level thread anchor_tutorial();
	
	flag::wait_till( "start_barge" );
	level thread cargo_ship_rocker();
	level thread port_assault_vo();

	trigger::wait_till( "end_port_assault" );
	
	level skipto::objective_completed( "objective_port_assault" );
}

function port_assault_done( str_objective, b_starting, b_direct, player )
{
}

function barge_assault( str_objective, b_starting )
{	
	if ( b_starting )
	{
		level thread blackstation_utility::water_manager();
		level thread tanker_movement();
		
		level thread cargo_ship_rocker();
				
		blackstation_utility::init_hendricks( "objective_barge_assault" );
		
		level.ai_hendricks.is_in_safety_zone = false;
				
		t_surge = GetEnt( "port_assault_low_surge", "targetname" );
		level thread blackstation_utility::setup_surge( t_surge );
		
		level clientfield::set( "pier_wave_init", 1 );
	}
	
	level thread blackstation_utility::player_rain_intensity( "heavy" );
	level thread pier_events();
	level thread truck_pier();
	level thread spawn_pier_guards();
	level thread pier_watcher();
	level thread barge_assault_vo();
	level thread pre_breach();
	level thread lightning_barge();
	level thread lightning_barge_clear();
	level thread pier_guard_smash();
	
	flag::wait_till( "activate_barge_ai" );
	
	level clientfield::set( "pier_wave_play", 1 );

	level flag::wait_till( "tanker_go" );
	
	level skipto::objective_completed( "objective_barge_assault" );
}

function barge_assault_done( str_objective, b_starting, b_direct, player )
{	
	objectives::complete( "cp_level_blackstation_secure_cargo" );
}

function storm_surge( str_objective, b_starting )
{
	if ( b_starting )
	{
		blackstation_utility::init_hendricks( "objective_storm_surge" );
		
		level thread tanker_movement();
		level cargo_ship_rocker();
		level thread enable_breach_triggers();
		level thread blackstation_utility::lightning_flashes( "lightning_pier", "tanker_ride" );
		
		trigger::wait_till( "storm_surge_start" );
	}
	
	level thread tanker_building_smash();  //TODO - temp until IGC implemented
	
	level flag::wait_till( "tanker_ride_done" );

	level skipto::objective_completed( "objective_storm_surge" );
}

function storm_surge_done( str_objective, b_starting, b_direct, player )
{	
	objectives::complete( "cp_level_blackstation_wheelhouse" );
	objectives::set( "cp_level_blackstation_rendezvous" );	
}

////////////////////////////////////////////////////////////////////
// ANCHOR INTRO
////////////////////////////////////////////////////////////////////

function anchor_tutorial()
{
	util::screen_message_create( &"CP_MI_SING_BLACKSTATION_USE_ANCHOR", undefined, undefined, undefined, 3 );
}

function hendricks_anchor_warning()
{
	level endon( "kill_warning_vo" );
	
	while( true )
	{
		level waittill( "weather_warning" );
		
		//We want Hendricks to always warn the first time
		if( !flag::get( "warning_vo_played" ) )
		{
			say_wind_warning();
			flag::set( "warning_vo_played" );
		}
		else//Otherwise he only warns randomly
		{
			if( RandomFloatRange( 0, 1 ) <= .2 )
			{
				say_wind_warning();
			}
		}
		
		wait .1;
	}
}

function say_wind_warning()
{
	switch( RandomIntRange( 0, 2 ) )
	{
		case 0:
			level.ai_hendricks dialog::say( "Anchor now!" );
			break;
			
		case 1:
			level.ai_hendricks dialog::say( "Deploy anchor!" );
			break;
			
		default:
			level.ai_hendricks dialog::say( "Anchor!" );
			break;
	}
}

////////////////////////////////////////////////////////////////////
// PORT ASSAULT
////////////////////////////////////////////////////////////////////

function flying_boat()
{
	e_boat = GetEnt( "debris_boat", "targetname" );
	s_start = struct::get( "flying_boat" );
	s_end = struct::get( s_start.target );
	
	e_boat MoveTo( s_start.origin, 0.05 );
	e_boat waittill( "movedone" );
	
	e_boat RotatePitch( -30, 1 );
	e_boat MoveTo( s_end.origin, 1 );
	e_boat waittill( "movedone" );
	e_boat Delete();	
}

function kane_missiles( b_play_full )
{
	if( !b_play_full )
	{
		trigger::wait_till( "trigger_hendricks_anchor_done" );
		
		trigger::use( "hotel_wait" );
		
		flag::wait_till( "anchor_intro_done" );
	}
	
	level.ai_hendricks ai::set_ignoreall( true );
	
	trigger::wait_till( "port_assault_windgust" );
	
	level flag::set( "wind_gust" );
	
	level dialog::remote( "Hold your position." );  //Kane
	
	level thread launch_missiles( true );
	
	level dialog::remote( "Drone strike inbound." );  //Kane
	
	wait 2;  //pause to assess missile strike
	
	level dialog::remote( "Negative effect, second missile strike inbound." );  //Kane
	
	level thread launch_missiles();
	
	wait 4;  //Give time for missile to fly
	
	level dialog::remote( "The winds are too strong, you guys are on your own. Assault the cargo ship and find out what's in those containers!" );  //Kane
	
	if ( !level flag::get( "hotel_exit" ) )  //flag set by "trigger_hotel_exit"
	{
		trigger::use( "triggercolor_drone_strike" );
		
		level.ai_hendricks dialog::say( "Let's move!" );
	}
	
	level.ai_hendricks ai::set_ignoreall( false );
	
	level flag::set( "drone_strike" );
}

//HACK - replace with fxanim
function launch_missiles( b_first_volley = false )
{
	s_missile_origin = struct::get( "missile_origin" );
	a_s_target = struct::get_array( "missile_target" );
	a_s_target2 = struct::get_array( "missile_target2" );
	
	weapon = GetWeapon( "smaw" );
	
	if( !b_first_volley )
	{
		for( x = 0; x < a_s_target.size; x++ )
		{
			MagicBullet( weapon, s_missile_origin.origin, a_s_target2[x].origin );
		}
	}
	else
	{
		for( x = 0; x < a_s_target.size; x++ )
		{
			MagicBullet( weapon, s_missile_origin.origin, a_s_target[x].origin );
		}
	}
}

function lightning_port_assault()
{
	level endon( "surge_done" );
	
	level thread blackstation_utility::lightning_flashes( "lightning_port", "surge_done" );
}

function port_assault_debrisfly()
{
	spawner::simple_spawn_single( "falling_guy", &falling_guy_spawnfunc );
	spawner::simple_spawn_single( "rooftop_still", &windblown_guy_spawnfunc, "still" );
	spawner::simple_spawn_single( "rooftop_center", &windblown_guy_spawnfunc, "center" );
	spawner::simple_spawn_single( "rooftop_left", &windblown_guy_spawnfunc, "left" );
	spawner::simple_spawn_single( "rooftop_right", &windblown_guy_spawnfunc, "right" );
	
	level flag::wait_till( "wind_gust" );
	
	e_dish = GetEnt( "debris_satellite_dish", "targetname" );
	e_solar = GetEnt( "debris_solar_panel", "targetname" );
	
	wait 0.5;  //stagger debris flying
	
	e_solar PhysicsLaunch( e_solar.origin, ( -350, 250, 250 ) );
	
	wait 0.5;  //stagger debris flying
	
	e_dish PhysicsLaunch( e_dish.origin, ( -450, 300, 250 ) );
}

function windblown_guy_spawnfunc( str_dir )
{
	self endon( "death" );
	
	self ai::set_behavior_attribute( "sprint", true );
	self ai::set_ignoreme( true );
	self ai::set_ignoreall( true );
	self.goalradius = 1;
	self SetGoal( self.origin );
		
	level flag::wait_till( "wind_gust" );
	
	wait 1.7;  //let missiles hit
	
	switch( str_dir )  //TODO - temp wind react anims
	{
		case "still":
			self scene::play( "cin_gen_vign_offbalance", self );
			self thread port_assault_retreat();
			break;

		case "center":
			self scene::play( "cin_gen_vign_offbalance_center", self );
			self thread port_assault_retreat();
			break;
		
		case "left":
			self scene::play( "cin_gen_vign_offbalance_left", self );
			self thread port_assault_retreat();
			break;
			
		case "right":
			self scene::play( "cin_gen_vign_offbalance_right", self );
			self thread port_assault_retreat();
			break;
	}
}

function port_assault_retreat()  //self = ai
{
	self endon( "death" );
	
	wait RandomFloatRange( 0.3, 1.0 );  //stagger retreat
	
	self ai::set_ignoreme( false );
	self ai::set_ignoreall( false );
	
	s_start = struct::get( "retreat_pt1" );
	s_mid = struct::get( "retreat_pt2" );
	s_end = struct::get( "retreat_pt3" );
	vol_port = GetEnt( "vol_port_building", "targetname" );
	
	self.goalradius = 2048;
	
	self SetGoal( s_start.origin + ( RandomInt( 80 ), RandomInt( 80 ), 0 ), true );
	self waittill( "goal" );
	self SetGoal( s_mid.origin + ( RandomInt( 80 ), RandomInt( 80 ), 0 ), true );
	self waittill( "goal" );
	self SetGoal( s_end.origin + ( RandomInt( 120 ), RandomInt( 120 ), 0 ), true );
	self waittill( "goal" );
	
	self ClearForcedGoal();
	
	self SetGoal( vol_port );
}

function falling_guy_spawnfunc()  //self = ai
{
	self endon( "death" );
	
	self ai::set_behavior_attribute( "sprint", true );
	self ai::set_ignoreme( true );
	self ai::set_ignoreall( true );
	self.goalradius = 1;
			
	self SetGoal( GetNode( "node_fall_guy", "targetname" ), true );
	
	level flag::wait_till( "wind_gust" );
	
	//HACK - waiting for animation
	//wait 1.7;  //allow time for ai to react
	
	self scene::play( "cin_gen_vign_offbalance", self );
	
	self StartRagdoll();
	self LaunchRagdoll( ( -100, 50, 80 ) );
	self Kill();
}

function surge_debris_portstart()
{
	trigger::wait_till( "trigger_surge_debris1" );
	
	s_start = struct::get( "surge_port_start" );
	
	a_e_debris = GetEntArray( "debris_surge_0", "targetname" );
		
	level thread blackstation_utility::water_surge( s_start, a_e_debris, "end_surge_start" );
}

function surge_debris_powerplant()
{
	level flag::wait_till( "end_surge_start" );
	
	s_start = struct::get( "surge_port_substation" );
	
	a_e_debris = GetEntArray( "debris_surge_1", "targetname" );
		
	level thread blackstation_utility::water_surge( s_start, a_e_debris, "start_barge" );
}

function surge_debris_restaurant()
{
	level flag::wait_till( "start_barge" );
	
	s_start = struct::get( "surge_port_restaurant" );
	
	level thread blackstation_utility::water_surge( s_start, undefined, "end_surge_rest" );
}

function surge_debris_portbuilding()
{
	s_start = struct::get( "surge_port_authority" );
	
	a_e_debris = GetEntArray( "debris_surge_2", "targetname" );
	a_e_cover = GetEntArray( "wharf_debris", "targetname" );
	
	foreach( e_cover in a_e_cover )
	{
		e_cover thread blackstation_utility::set_model_scale();
	}
		
	//TODO - add extra non-cover debris
	//level thread blackstation_utility::water_surge( s_start, a_e_debris, "wave_done" );
	level thread blackstation_utility::water_surge( s_start, a_e_cover, "wave_done" );
	level thread port_covernode_handler();
}

function port_covernode_handler()
{
	level endon( "enter_port" );
	
	//TODO - quick and dirty implementation, find a better way
	a_nd_surge1 = GetNodeArray( "covernode_surge_1", "script_noteworthy" );
	a_nd_surge2 = GetNodeArray( "covernode_surge_2", "script_noteworthy" );
	a_nd_surge3 = GetNodeArray( "covernode_surge_3", "script_noteworthy" );
	
	foreach( nd_cover in a_nd_surge2 )
	{
		SetEnableNode( nd_cover, false );
	}
	foreach( nd_cover in a_nd_surge3 )
	{
		SetEnableNode( nd_cover, false );
	}
	
	level flag::wait_till( "cover_switch" );
	
	foreach( nd_cover in a_nd_surge2 )
	{
		SetEnableNode( nd_cover, true );
	}
	
	wait 0.1;  //allow time for node to be enabled
	
	trigger::use( "triggercolor_port_cover2" );
	
	foreach( nd_cover in a_nd_surge1 )
	{
		SetEnableNode( nd_cover, false );
	}
		
	level flag::clear( "cover_switch" );
	
	level flag::wait_till( "cover_switch" );
	
	foreach( nd_cover in a_nd_surge3 )
	{
		SetEnableNode( nd_cover, true );
	}
	
	wait 0.1;  //allow time for node to be enabled
	
	trigger::use( "triggercolor_port_cover3" );
	
	foreach( nd_cover in a_nd_surge2 )
	{
		SetEnableNode( nd_cover, false );
	}
}

function port_assault_enemies()
{
	trigger::wait_till( "trigger_port_sniper" );
	
	level flag::set( "end_surge_rest" );  //no more waves from restaurant
	
	spawn_manager::enable( "sm_pa_sniper" );
	
	trigger::wait_till( "trigger_port_building" );
	
	level thread surge_debris_portbuilding();
	level thread port_enter();
	level thread port_assault_interior();
	level thread swept_away_guys();
			
	spawn_manager::enable( "sm_port_authority" );
	
	wait 3;  //allow time for battle to start before spawning more
	
	spawn_manager::enable( "sm_rooftop_suppressor" );
	
	spawn_manager::wait_till_cleared( "sm_pa_sniper" );
	
	level flag::set( "swept_away" );  //spawns guys who run out into the water to get swept away
	
	spawn_manager::wait_till_cleared( "sm_rooftop_suppressor" );
	spawn_manager::wait_till_ai_remaining( "sm_port_authority", 3 );
	
	level flag::set( "enter_port" );  //also set by trigger "hurry_vo"
}

function swept_away_guys()
{
	level flag::wait_till( "swept_away" );  //set by trigger_port_truck or clearing rooftop snipers
	
	spawner::simple_spawn( "port_authority_swept" );
}

function port_enemy_spawnfunc()  //self = ai
{
	self endon( "death" );
	
	self.grenadeammo = 0;
	self.b_swept = false;
}

function port_enter()
{
	level flag::wait_till( "enter_port" );
	
	trigger::use( "triggercolor_port_building" );
	
	level.ai_hendricks dialog::say( "Move up!" );
}

function port_assault_truck()
{
	trigger::wait_till( "trigger_truck_port" );
		
	vh_truck = vehicle::simple_spawn_single( "port_assault_tech" );
	
	nd_start = GetVehicleNode( vh_truck.target, "targetname" );
	
	vh_truck thread vehicle::get_on_and_go_path( nd_start );
}

function port_assault_interior()
{
	trigger::wait_till( "trigger_port_interior" );
	
	spawner::add_spawn_function_group( "port_interior", "targetname", &port_interior_spawnfunc );
	
	spawn_manager::enable( "sm_port_interior" );
}

function port_interior_spawnfunc()  //self = port interior ai
{
	self endon( "death" );
	
	trigger::wait_till( "trigger_port_advance" );
	
	while( 1 )
	{
		e_target = util::get_closest_player( self.origin, "allies" );
	
		v_player_pos = GetClosestPointOnNavMesh( e_target.origin, 82, 32 );
		
		if ( isdefined( v_player_pos ) )
		{
			a_v_points = GetNavPointsInRadius( v_player_pos, self.engageMinDist, self.engageMaxDist );
			
			self SetGoal( a_v_points[RandomInt( a_v_points.size )], true );
		}
		
		wait 3;  //allow time for ai to move a bit
	}
}

//Get the crane/container in place to serve as a blocker for the driver
//HACK - replace with fxanim
function setup_crane()
{
	e_container = GetEnt( "barge_container_large_white_01", "targetname" );
	e_crane = GetEnt( "dock_crane_top", "targetname" );
	
	t_container = GetEnt( "dock_crane_hurt", "targetname" );
	t_container EnableLinkTo();
	t_container LinkTo( e_container );
	
	e_container RotateYaw( 60, 0.05 );
	e_container MoveTo( e_container.origin + (0,0,-15), 0.05 );
	e_container waittill( "rotatedone" );
	e_container LinkTo( e_crane );
	
	e_crane RotateYaw( 45, 0.05 );
	e_crane waittill( "rotatedone" );
	
	spawner::simple_spawn_single( "crane_operator", &crane_operator );
}

//self = ai
function crane_operator()
{
	self thread ignore_crane_operator();
	self.goalradius = 4;
	self ai::set_ignoreall( true );
	
	//HACK - replace with anim/fxanim
	e_crane = GetEnt( "dock_crane_top", "targetname" );
	e_container = GetEnt( "barge_container_large_white_01", "targetname" );	
	e_bottom = GetEnt( "dock_crane_bottom", "targetname" );
	
	trigger::wait_till( "trigger_dock" );
	
	e_container = GetEnt( "barge_container_large_white_01", "targetname" );
	e_container Unlink();
	e_container MoveTo( e_container.origin + (0,0,55), 2 );
	e_container waittill( "movedone" );
		
	e_container LinkTo( e_crane );
	
	e_crane RotateYaw( 45, 3 );
	e_crane waittill( "rotatedone" );
	
	self ai::set_ignoreall( false );
	
	if( IsAlive( self ) )
	{
		self waittill( "death" );
	}
	
	e_container Unlink();
	e_container MoveTo( e_container.origin + (0,0,-140), .25 );
	e_crane RotateYaw( 270, 5 );
	
	e_container waittill( "movedone" );
	
	t_container = GetEnt( "dock_crane_hurt", "targetname" );
	t_container Delete();
	
	wait 2.8;  //TODO - replace with notetracks from anim
	
	level flag::set( "dock_crane_active" );
}

function ignore_crane_operator()  //self = crane operator ai
{
	self ai::set_ignoreme( true );
	
	trigger::wait_till( "trigger_dock" );
	
	self ai::set_ignoreme( false );
}



function cargo_ship_rocker()
{
	level endon( "stop_cargo_rocker" );
	
	e_barge = GetEnt( "bs_dock_tugboat", "targetname" );
	
	e_barge prep_barge();
	e_barge thread cargo_ship_roll();
	e_barge thread cargo_ship_bob();
	e_barge thread barge_face_tanker();
}

//self = barge
function prep_barge()
{
	//Hook up traversal so Hendricks can get on
	e_traversal = GetNode( "barge_traversal", "script_noteworthy" );
	LinkTraversal( e_traversal );
	
	e_align = util::spawn_model( "tag_origin", self.origin + (130,0,138) );//HACK tmp offset until align node is fixed//tag_align_hendricks_barge
	e_align.targetname = "barge_align";
	e_align LinkTo( self );
	
	e_barge_door = GetEnt( "barge_door", "targetname" );
	e_barge_door LinkTo( self );
	e_barge_door2 = GetEnt( "barge_door_2", "targetname" );
	e_barge_door2 LinkTo( self );	
	
	a_e_barge_roof = GetEntArray( "barge_roof", "targetname" );
	foreach( e_barge_roof in a_e_barge_roof )
	{
		e_barge_roof LinkTo( self );
	}
	
	a_t_barge = GetEntArray( "barge_trigger", "script_noteworthy" );
	foreach( trigger in a_t_barge )
	{
		trigger EnableLinkTo();
		trigger LinkTo( self );		
	}
	
	e_wheel = GetEnt( "barge_wheel", "targetname" );
	e_wheel LinkTo( self );
	
	e_fx = GetEnt( "barge_wave_fx", "targetname" );
	e_fx LinkTo( self );
	
	e_container_door_left = GetEnt( "barge_container_door_left", "targetname" );
	e_container_door_left RotateTo( (0, -5, 0), 0.05 );
	e_container_door_left waittill( "rotatedone" );
	e_container_door_left LinkTo( self );
	e_container_door_right = GetEnt( "barge_container_door_right", "targetname" );
	e_container_door_right RotateTo( (0, 5, 0), 0.05 );
	e_container_door_right waittill( "rotatedone" );	
	e_container_door_right LinkTo( self );
	
	a_deck_ents = GetEntArray( "barge_ents", "script_noteworthy" );
	foreach( deck_ent in a_deck_ents )
	{
		deck_ent LinkTo( self );
	}

	a_deck_ammo = GetEntArray( "barge_ammo", "targetname" );
	foreach( deck_ammo in a_deck_ammo )
	{
		deck_ammo LinkTo( self );	
	}
	
	a_t_breach = GetEntArray( "player_breach_trigger", "script_noteworthy" );
	foreach( trigger in a_t_breach )
	{
		e_waypoint = GetEnt( trigger.target, "targetname" );
		e_player_link = GetEnt( e_waypoint.target, "targetname" );
		
		trigger SetHintString( &"CP_MI_SING_BLACKSTATION_BREACH_STACK" );
		trigger EnableLinkto();
		trigger LinkTo( self );
		trigger SetInvisibleToAll();
		
		e_waypoint LinkTo( self );
		e_player_link LinkTo( self );
	}
	
	nd_wheelhouse = GetNode( "wheelhouse_traversal", "targetname" );
	LinkTraversal( nd_wheelhouse );
	
	a_e_pos = GetEntArray( "tanker_ready_pos", "targetname" );  //player positions inside wheelhouse
	foreach( e_pos in a_e_pos )
	{
		e_pos LinkTo( self );
	}
	
	level thread watch_deck_container();
	level thread barge_breach();
	level thread tanker_ride_waypoint();
}

	/*barge_container_large_blue_01
		barge_container_large_blue_02
		barge_container_small_red_01
		barge_container_small_orange_01
		barge_container_small_white_01*/

//self = cargo ship
function cargo_ship_roll()
{
	level endon( "stop_cargo_rocker" );
	
	const n_distance = 3;
	const n_time = 2;
	const n_wait = .2;
	
	self RotateRoll( -n_distance, n_time );
	self waittill( "rotatedone" );
	wait n_wait;//Wait before moving
		
	while( true )
	{
		self RotateRoll( n_distance * 2, n_time * 2 );
		self waittill( "rotatedone" );
		wait n_wait;//Wait before moving
		self RotateRoll( -n_distance * 2, n_time * 2 );
		self waittill( "rotatedone" );
		wait n_wait;//Wait before moving		
	}	
}

//self = cargo ship
function cargo_ship_bob()
{
	level endon( "stop_cargo_rocker" );
	
	const n_distance = 30;
	const n_time = 5;
	const n_wait = .1;
	
	while( true )
	{
		self MoveTo( self.origin + ( 0, 0, n_distance ), n_time );
		self waittill( "movedone" );
		wait n_wait;//Wait before moving
		self MoveTo( self.origin + ( 0, 0, -n_distance ), n_time );
		self waittill( "movedone" );
		wait n_wait;//Wait before moving
	}
}

function barge_face_tanker()  //self = barge
{
	v_ang = self.angles;
	v_org = self.origin;
	
	level flag::wait_till( "tanker_smash" );
	
	level notify( "stop_cargo_rocker" );
	
	self RotateTo( v_ang, 1 );
	self MoveTo( v_org, 1 );
	
	self waittill( "movedone" );
	
	e_fx = GetEnt( "barge_wave_fx", "targetname" );
	e_fx thread fx::play( "wave_pier", e_fx.origin, undefined, 2, true );
	
	Earthquake( 1, 1.5, e_fx.origin, 1000 );
	
	level flag::set( "roof_fly" );
	
	self RotateRoll( -15, 1 );
	self waittill( "rotatedone" );
	
	wait 0.3;  //allow barge to settle
	
	self RotateRoll( 20, 1 );
	self waittill( "rotatedone" );
	
	self RotateRoll( -5, 1 );
	self waittill( "rotatedone" );
	
	level flag::set( "tanker_face" );
	
	self RotateYaw( 60, 4 );
	self waittill( "rotatedone" );
	
	self thread cargo_ship_roll();
	self thread cargo_ship_bob();
	
	level flag::wait_till( "tanker_hit" );
	
	e_waypt = GetEnt( "waypt_tanker_smash", "targetname" );
	e_waypt thread fx::play( "wave_pier", e_waypt.origin, undefined, 2, true );
}

function pier_events()
{
	//level thread setup_crane();  //TODO - wait for crane driver anim
	level thread truck_wave();
}

function pier_watcher()
{
	trigger::wait_till( "hendricks_hurry" );
		
	level blackstation_utility::setup_wave( GetEnt( "pier_waves", "targetname" ) );
}

function pre_breach( b_skipto = false )
{	
	//waittill deck cleared
	spawn_manager::wait_till_cleared( "sm_barge" );
	spawn_manager::wait_till_cleared( "sm_barge_cqb" );
	
	level.ai_hendricks dialog::say( "Kane, we've secured the cargo. Once the wheelhouse is clear, we will head to the rendevous point." );//Hendricks
	level.ai_hendricks dialog::say( "Alright, let's clear the wheelhouse." );//Hendricks
	
	level thread breach_nag();
	
	objectives::complete( "cp_level_blackstation_secure_cargo" );

	level notify( "kill_hendricks_anchor" );
	
	trigger::use( "hendricks_breach" );
	
	e_align = GetEnt( "barge_align", "targetname" );
	//e_align scene::init( "cin_bla_06_06_portassault_1st_breach" );//TODO need updated anim
		
	//Breach is now available
	level thread enable_breach_triggers();
}

function enable_breach_triggers()
{
	//Get rid of triggers we don't need
	n_base = level.players.size + 1;
	
	for( x=n_base ; x<=4 ;x++ )
	{
		t_player_breach = GetEnt( "breach_player_" + x, "targetname" );
		level flag::set( t_player_breach.script_flag_set );//Set the triggers flag
		e_waypoint = GetEnt( t_player_breach.target, "targetname" );
		e_waypoint Delete();
		t_player_breach Delete();
	}
	
	foreach( player in level.players )
	{
		player thread player_breach_watcher();
	}
	
	//Set waypoint on the remaining structs
	a_e_player_breach = GetEntArray( "breach_waypoint", "script_noteworthy" );
	objectives::set( "cp_level_blackstation_wheelhouse", a_e_player_breach );
	
	//Set watcher on remaining triggers
	a_t_player_breach = GetEntArray( "player_breach_trigger", "script_noteworthy" );
	
	foreach( trigger in a_t_player_breach )
	{
		trigger SetVisibleToAll();
		trigger thread watch_for_player_stack();
	}
	
	level flag::set( "breach_active" );
	
	level flag::wait_till_all( Array( "player_1_stacked", "player_2_stacked", "player_3_stacked", "player_4_stacked" ) );  //flags set when player triggers
	
	level clientfield::set( "pier_wave_play", 0 );  //turn off pier waves
	
	objectives::complete( "cp_level_blackstation_wheelhouse", a_e_player_breach );
}

//self = trigger
function watch_for_player_stack()
{
	self endon( "death" );
	
	self waittill( "trigger", e_player );
	
	e_player SetLowReady( true );
	
	e_waypoint = GetEnt( self.target, "targetname" );
	objectives::hide_for_target( "cp_level_blackstation_wheelhouse", e_waypoint );
	e_player.e_linkto = GetEnt( e_waypoint.target, "targetname" );
	
	e_player FreezeControls( true );
	e_player SetOrigin( e_player.e_linkto.origin );
	e_player SetPlayerAngles( e_player.e_linkto.angles );
	
	//TODO - play idle anim to lock player in
	//HACK
	e_player PlayerLinkToDelta( e_player.e_linkto, undefined, 0.5, 180, 180, 180, 180, 1, 0 );
	
	a_t_player_breach = GetEntArray( "player_breach_trigger", "script_noteworthy" );
	
	foreach( trigger in a_t_player_breach )
	{
		trigger SetInvisibleToPlayer( e_player );
	}
	
	level flag::set( self.script_flag_set );
	
	self Delete();
}

function player_breach_watcher()  //self = player
{
	level endon( "wheelhouse_breached" );
	
	self waittill( "death" );  //Need to update triggers if a player dies while others are stacked
	
	n_base = level.players.size + 1;
	
	for( x=n_base ; x<=4 ;x++ )
	{
		t_player_breach = GetEnt( "breach_player_" + x, "targetname" );
		
		if ( isdefined( t_player_breach ) )
		{
			level flag::set( t_player_breach.script_flag_set );//Set the triggers flag
			e_waypoint = GetEnt( t_player_breach.target, "targetname" );
			objectives::hide_for_target( "cp_level_blackstation_wheelhouse", e_waypoint );
			e_waypoint Delete();
			t_player_breach Delete();
		}
	}
}

//self = trigger
function breach_nag()
{
	level endon( "wheelhouse_breached" );
	
	while( true )
	{
		wait RandomFloatRange( 5, 7 );
		
		if( level.players.size > 1 )
		{
			level.ai_hendricks dialog::say( "Everyone over here!" );//Hendricks
		}
		else
		{
			level.ai_hendricks dialog::say( "Over here!" );//Hendricks	
		}
	}
}

function barge_breach()
{	
	e_align = GetEnt( "barge_align", "targetname" );
	
	level flag::wait_till_all( Array( "player_1_stacked", "player_2_stacked", "player_3_stacked", "player_4_stacked" ) );  //flags set when player triggers
	
	//e_align scene::init( "cin_bla_06_06_portassault_1st_breach_enemy" );  //TODO - wait for new anims
	
	level notify( "wheelhouse_breached" );
	
	//e_align thread scene::stop( "cin_bla_06_06_portassault_1st_breach" );//Just stop for now until we get updated anims to fit new geo
	
	spawner::add_spawn_function_group( "wheelhouse_target", "targetname", &wheelhouse_spawnfunc, false );
	spawner::simple_spawn( "wheelhouse_target" );
	
	spawner::add_spawn_function_group( "wheelhouse_enemy", "targetname", &wheelhouse_spawnfunc, true );
	spawn_manager::enable( "sm_wheelhouse" );
	
	wait .1;//HACK slight delay until we get new anims
	
	//HACK - get rid of the doors
	e_barge_door = GetEnt( "barge_door", "targetname" );
	e_barge_door2 = GetEnt( "barge_door_2", "targetname" );
	e_barge_door thread barge_doors( "left" );
	e_barge_door2 thread barge_doors( "right" );
	
	wait 0.2;  //allow doors to start opening first
	
	//e_align thread scene::play( "cin_bla_06_06_portassault_1st_breach_enemy" );	//TODO - wait for new anims
	
	level thread breach_slow_time();
	
	level.ai_hendricks thread hendricks_enter_wheelhouse();
	
	wait 0.3;  //allow hendricks to enter first
	
	foreach( player in level.players )
	{
		player thread enter_wheelhouse();
	}
	
	spawner::waittill_ai_group_ai_count( "group_wheelhouse", 0 );
	spawner::waittill_ai_group_ai_count( "group_wheelhouse_backup", 0 );
	
	level notify( "barge_breach_cleared" );//Kill slowmo if still active
	
	objectives::complete( "cp_level_blackstation_wheelhouse" );
	
	wait 2;  //delay so that tanker smash doesn't kick off right away
	
	level flag::set( "tanker_smash" );
	
	level clientfield::set( "water_level", 0 );
}

function hendricks_enter_wheelhouse()  //self = hendricks
{
	self colors::disable();
	
	nd_tanker = GetNode( "node_hendricks_tanker", "targetname" );
	
	self ai::set_ignoreall( true );
	
	e_org = GetEnt( "hendricks_breach_linkto", "targetname" );
	self skipto::teleport_single_ai( e_org );
	self OrientMode( "face angle", e_org.angles[1] );
	self LinkTo( e_org );
	
	e_org Unlink();
	e_org MoveTo( GetEnt( e_org.target, "targetname" ).origin, 0.7 );
	e_org waittill( "movedone" );
	e_org Delete();
	
	self SetGoal( self.origin, true );
	
	self hendricks_concussive_wave();
	
	self ai::set_ignoreall( false );
		
	level flag::wait_till( "roof_fly" );
	
	self SetGoal( nd_tanker, true );
	self waittill( "goal" );
	
	self ClearForcedGoal();
}

#using_animtree( "generic" );
function hendricks_concussive_wave()  //self = hendricks - TODO - temp until "real" version fixed
{
	if( self.a.pose =="stand" )
		type = "stn";
	else
		type = "crc";

	self OrientMode( "face default" );
	self AnimScripted( "ai_cybercom_anim", self.origin, self.angles, "ai_base_rifle_"+type+"_exposed_cybercom_activate" );
	self waittillmatch( "ai_cybercom_anim", "fire" );
	
	self create_concussion_wave();
}

function create_concussion_wave()  //TODO - temp, copied from _cybercom_gadget_concussive_wave.gsc
{
	enemies = ArrayCombine( GetAISpeciesArray( "axis", "all" ), GetAISpeciesArray( "team3", "all" ), false,false );
	
	PlayFx( level._effect["concussive_wave"], self.origin );

	// Determine which enemies are close enough to knock down.
	// Also determine which enemies are close enough to do damage to.
	if ( isdefined( enemies ) && enemies.size )
	{
		foreach ( enemy in enemies )
		{
			if ( !isdefined( enemy ) || !isdefined( enemy.origin ) )
			{
				continue;
			}
			
			if ( ( isdefined( enemy.b_concussive ) && enemy.b_concussive ) )
			{
				enemy DoDamage( ( enemy.health * 0.5 ), enemy.origin );
			}
			else
			{
				enemy thread scene::play( "cin_gen_xplode_death_" + RandomIntRange( 1, 4 ), enemy );
			}
		}
	}
}

function enter_wheelhouse()  //self = player
{
	self endon( "death" );
	
	self.e_linkto Unlink();
	
	e_entry = GetEnt( self.e_linkto.target, "targetname" );
	self.e_linkto RotateTo( e_entry.angles, 0.25 );
	self.e_linkto MoveTo( e_entry.origin, 0.25 );
	self.e_linkto waittill( "movedone" );
	
	self SetLowReady( false );
		
	e_goal = GetEnt( e_entry.target, "targetname" );
	self.e_linkto MoveTo( e_goal.origin, 0.5 );
	self.e_linkto waittill( "movedone" );
		
	self Unlink();	
}

function barge_doors( str_side )  //self = door model
{
	self Unlink();
	
	if ( str_side == "left" )
	{
		self MoveY( -48, 0.3 );
	}
	else
	{
		self MoveY( 48, 0.3 );
	}
	
	self waittill( "movedone" );
	self Delete();
}

function wheelhouse_spawnfunc( b_concuss )  //self = wheelhouse ai
{
	self endon( "death" );
	
	self.b_concussive = b_concuss;
	
	self ai::set_ignoreall( true );
	self.goalradius = 1;
	
	wait .05;  //simulate reaction anims
	
	self ai::set_ignoreall( false );
}

function breach_slow_time()
{
	level endon( "barge_breach_cleared" );
	
	const n_timescale = .25;
	const n_default = 1.0;
	const n_time = 0.016;		
	
	SetSlowMotion( n_default, n_timescale, n_time );
	foreach( player in level.players )
	{
		player SetMoveSpeedScale( n_timescale );
	}
	
	level thread reset_timescale( n_timescale, n_default, n_time );
}

function reset_timescale( n_timescale, n_default, n_time )
{
	util::waittill_any_timeout( 3, "barge_breach_cleared" );
	SetSlowMotion( n_timescale, n_default, n_time );
	foreach( player in level.players )
	{
		player SetMoveSpeedScale( n_default );
	}	
}

function port_assault_vo()
{
	trigger::wait_till( "hurry_vo" );
	
	level dialog::remote( "You must hurry, the barge will depart soon!" );//Kane
}

function barge_assault_vo()
{	
	trigger::wait_till( "hendricks_hurry" );
	level.ai_hendricks dialog::say( "Let's go!" );//Hendricks
}

//HACK - replace with fxanim
function watch_deck_container()
{
	e_container = GetEnt( "barge_container_small_orange_01", "targetname" );
	t_container = GetEnt( "deck_crane_hurt", "targetname" );
	t_container EnableLinkTo();
	t_container LinkTo( e_container );
	
	trigger::wait_till( "deck_crane" );//damage trigger	
	
	level flag::set( "deck_crane_active" );
	
	e_container Unlink();
	e_container MoveTo( e_container.origin - (0,0,80), .8, .15 );
	e_container waittill( "movedone" );
	e_container RotateTo( (0,0,-180), 2, .15 );
	e_container MoveTo( e_container.origin - (0,-100,0), 1, .15 );
	e_container waittill( "movedone" );
	e_container MoveTo( e_container.origin - (0,0,400), 1, .15 );
	e_container waittill( "movedone" );
	e_container Delete();
}

function truck_wave()
{
	//HACK - replace with fxanim
	s_wave = struct::get( "wave_technical", "script_noteworthy" );
	e_wave = GetEnt( "temp_pier_wave", "targetname" );
	t_wave = GetEnt( e_wave.target, "targetname" );
	
	e_wave Ghost();
	
	level waittill( "wave_hit" );
	
	t_wave thread blackstation_utility::ai_wave_trigger_tracker();
	
	e_wave.origin = s_wave.origin;
	e_wave.angles = s_wave.angles;
	
	e_wave MoveTo( e_wave.origin + (0,0,150), .1 );
	e_wave waittill( "movedone" );
	e_wave MoveTo( e_wave.origin + (-450,0,0), 2 );
	
	e_wave thread blackstation_utility::play_temp_wave_fx();
		
	e_wave waittill( "movedone" );
	e_wave MoveTo( e_wave.origin + (0,0,-150), .1 );
}

//self = vehicle
function setup_port_technical()
{
	self turret::enable( 1, true );
	
	self waittill( "reached_end_node" );

	self thread blackstation_utility::truck_unload( "passenger1" );
	self thread blackstation_utility::truck_unload( "driver" );
	
	while( isdefined( self GetSeatOccupant( 0 ) ) )
	{
		wait 0.1;	
	}
	
	self MakeVehicleUsable();
	self SetSeatOccupied( 0 );
	
	self thread blackstation_utility::truck_gunner_replace( level.players.size, level.players.size, "activate_barge_ai" );
}

////////////////////////////////////////////////////////////////////
// BARGE ASSAULT
////////////////////////////////////////////////////////////////////

function wheelhouse_node_handler()
{
	a_nd_roof = GetNodeArray( "barge_roof", "script_linkname" );
	
	foreach ( nd_roof in a_nd_roof )
	{
		SetEnableNode( nd_roof, false );  //prevent ai outside from trying to get inside wheelhouse
	}
	
	level flag::wait_till( "breach_active" );
	
	foreach ( nd_roof in a_nd_roof )
	{
		SetEnableNode( nd_roof, true );
	}
}

function lightning_barge()
{
	level endon( "wave_done" );
	
	level flag::wait_till( "activate_barge_ai" );
	
	wait RandomFloatRange( 0.5, 1.5 );  //just for some randomness
	
	while( 1 )
	{
		level exploder::exploder_duration( "lightning_barge", 1 );  //build light located in script layer above barge
	
		level fx::play( "lightning_strike", struct::get( "lightning_boat" ).origin, ( -90, 0, 0 ) ); //TODO temp FX
		playsoundatposition ("amb_thunder_strike", struct::get( "lightning_boat" ).origin);//TODO origin offset
		
		wait RandomFloatRange( 6.0, 7.5 );
	}
}

function lightning_barge_clear()
{
	level flag::wait_till( "breach_active" );
	
	level thread blackstation_utility::lightning_flashes( "lightning_pier", "tanker_ride" );
}

function spawn_pier_guards()
{
	trigger::wait_till( "move_to_pier" );
	
	spawner::simple_spawn( "pier_guard", &pier_guard_behavior );
	
	trigger::wait_till( "trigger_pier_retreat" );
	
	level thread pier_guard_wave();
		
	trigger::wait_till( "trigger_dock" );
	
	spawner::simple_spawn_single( "crane_victim", &crane_victim );
	spawner::simple_spawn_single( "crane_victim2", &crane_victim );
	spawner::simple_spawn( "dock_guard" );
	
	trigger::wait_till( "trigger_barge" );
	
	spawn_manager::enable( "sm_barge" );
	
	trigger::wait_till( "trigger_barge_cqb" );
	
	spawner::add_spawn_function_group( "barge_cqb", "targetname", &barge_cqb_spawnfunc );
	
	spawn_manager::enable( "sm_barge_cqb" );
}

function pier_guard_smash()
{
	trigger::wait_till( "trigger_dock" );
	
	s_wave = struct::get( "wave_dockleft", "script_noteworthy" );
	e_wave = GetEnt( "pier_wave_dockleft", "targetname" );
	
	s_align = struct::get( "tag_align_hendricks_docks" );
	
	ai_smash = spawner::simple_spawn_single( "enemy01" );
		
	ai_smash endon( "death" );
	
	ai_smash ai::set_ignoreme( true );
	
	a_ai_enemies = GetAITeamArray( "axis" );
		
	ArrayRemoveValue( a_ai_enemies, ai_smash );
	
	s_align thread scene::play( "cin_bla_06_02_portassault_vign_post_smash" );
	
	wait 1;  //allow ai to move out of cover first
	
	level thread pier_wave_create( s_wave, e_wave, "left", a_ai_enemies );	
}

function barge_cqb_spawnfunc()  //self = barge ai
{
	self endon( "death" );
	
	self ai::set_behavior_attribute( "cqb", true );
	
	//TODO - remove cqb later
}

function crane_victim()  //self = ai
{
	self endon( "death" );
	
	self.goalradius = 4;
	
	level flag::wait_till( "dock_crane_active" );
	
	if ( self.targetname == "crane_victim2_ai" )
	{
		wait 0.5;  //TODO - replace with notetrack
	}
	
	self thread scene::play( "cin_bla_06_02_vign_wave_swept_right", self );
	
	self waittill( "swept_away" );
	
	self StartRagDoll();
	self LaunchRagDoll( ( 0, 100, 40 ) );  //TODO - get anim to launch these guys farther
	self Kill();
}

function pier_guard_behavior()  //self = ai
{
	self endon( "death" );
	
	self.goalradius = 4;
	self ai::set_ignoreme( true );
	
	trigger::wait_till( "hendricks_hurry" );
	
	self ai::set_ignoreme( false );
	
	trigger::wait_till( "trigger_pier_retreat" );
	
	self.goalradius = 2048;
	self ai::set_ignoreme( true );
		
	self SetGoal( GetEnt( "vol_dock", "targetname" ), true );
	self waittill( "goal" );
	
	self ai::set_ignoreme( false );
	
	self ClearForcedGoal();
}
	
function truck_pier()
{
	vh_truck = vehicle::simple_spawn_single( "truck_pier" );
	vh_truck util::magic_bullet_shield();
	vh_truck thread ignore_truck_riders();
	
	ai_gunner = GetEnt( "pier_truck_guy_ai", "targetname" );
	
	if ( IsAlive( ai_gunner ) )
	{
		ai_gunner thread truck_gunner_death();
	}
	
	vh_truck endon( "death" );
		
	trigger::wait_till( "hendricks_hurry" );
	
	nd_start = GetVehicleNode( "node_start_pier", "targetname" );
	
	vh_truck thread vehicle::get_on_and_go_path( nd_start );
	vh_truck turret::enable( 1, true );
	
	vh_truck waittill( "truck_crash" );
	
	vh_truck SetSpeedImmediate( 0 );
	vh_truck util::stop_magic_bullet_shield();
	
	vh_truck thread truck_wave_hit();
	
	vh_truck waittill( "wave" );
	
	vh_truck ResumeSpeed( 15 );
	
	vh_truck waittill( "reached_end_node" );
	
	vh_truck DoDamage( vh_truck.health, vh_truck.origin );
	
	level notify( "pier_end_node" );
}

function truck_cargo_blocker()  //self = cargo truck
{
	nd_start = GetVehicleNode( "node_cargo_truck", "targetname" );
	
	self thread vehicle::get_on_path( nd_start );
	
	self util::magic_bullet_shield();
	
	trigger::wait_till( "trigger_dock_truck" );
		
	self thread vehicle::go_path();
}

function truck_gunner_death()  //self = truck gunner ai
{
	self endon( "death" );
	
	level waittill( "wave_hit" );
	
	wait 1;  //allow time for wave to hit
	
	self Kill();
}

function truck_wave_hit()  //self = truck
{
	self endon( "death" );
	level endon( "wave_done" );
	
	t_wave = GetEnt( "truck_wave", "targetname" );
	
	while( !self IsTouching( t_wave ) )
	{
		wait 0.05;	
	}
		
	self notify( "wave" );
}

function ignore_truck_riders()  //self = vehicle
{
	while( self.riders.size < 2 )
	{
		wait 0.05;	
	}
	
	foreach( ai_rider in self.riders )
	{
		ai_rider ai::set_ignoreme( true );  //don't want Hendricks shooting at them so early
	}
	
	trigger::wait_till( "hendricks_hurry" );
	
	foreach( ai_rider in self.riders )
	{
		ai_rider ai::set_ignoreme( false );
	}
}

function pier_guard_wave()
{
	trigger::wait_till( "trigger_wave_retreat" );
	
	a_ai_enemies = GetAITeamArray( "axis" );
	ai_gunner = GetEnt( "pier_truck_guy_ai", "targetname" );
	
	if ( IsAlive( ai_gunner ) )
	{
		ArrayRemoveValue( a_ai_enemies, ai_gunner );
	}
	
	s_wave = struct::get( "wave_retreat", "script_noteworthy" );
	e_wave = GetEnt( "pier_wave_retreat", "targetname" );
	
	level thread pier_wave_create( s_wave, e_wave, "right", a_ai_enemies );
	
	trigger::wait_till( "trigger_wave_dock" );
	
	a_ai_enemies = GetAITeamArray( "axis" );
	ai_gunner = GetEnt( "pier_truck_guy_ai", "targetname" );
	
	if ( IsAlive( ai_gunner ) )
	{
		ArrayRemoveValue( a_ai_enemies, ai_gunner );
	}
	
	s_wave = struct::get( "wave_dockleft", "script_noteworthy" );
	e_wave = GetEnt( "pier_wave_dockleft", "targetname" );
	
	level thread pier_wave_create( s_wave, e_wave, "left", a_ai_enemies );
}

function pier_wave_create( s_wave, e_wave, str_side, a_ai )
{
	//TODO - replace with fx
	t_wave = GetEnt( e_wave.target, "targetname" );
	
	e_wave Ghost();	
	
	e_wave.origin = s_wave.origin;
	e_wave.angles = s_wave.angles;
	
	t_wave thread blackstation_utility::ai_wave_trigger_tracker();
		
	if ( str_side == "right" )
	{
		n_dist = 450;	
	}
	else
	{
		n_dist = -450;	
	}
	
	e_wave MoveTo( e_wave.origin + (0,0,150), .1 );
	e_wave waittill( "movedone" );
	e_wave MoveTo( e_wave.origin + (n_dist,0,0), 2 );
	
	e_wave thread blackstation_utility::play_temp_wave_fx();
		
	e_wave waittill( "movedone" );
	e_wave MoveTo( e_wave.origin + (0,0,-150), .1 );
}

////////////////////////////////////////////////////////////////////
// STORM SURGE
////////////////////////////////////////////////////////////////////

function tanker_building_smash()
{
	e_linkto1 = GetEnt( "tanker_building_linkto1", "targetname" );
	e_linkto2 = GetEnt( "tanker_building_linkto2", "targetname" );
	
	e_gate = GetEnt( "tanker_temple_01", "targetname" );
	e_building = GetEnt( "tanker_temple_02", "targetname" );
	
	e_gate LinkTo( e_linkto1 );
	e_building LinkTo( e_linkto2 );
	
	trigger::wait_till( "trigger_tanker_gate" );
	
	Earthquake( 0.5, 0.3, e_linkto1.origin, 2000 );
	
	e_linkto1 MoveZ( -500, 2 );
	
	trigger::wait_till( "trigger_tanker_building" );
	
	Earthquake( 0.8, 1.0, e_linkto2.origin, 2000 );
	
	e_linkto2 RotatePitch( -90, 4 );
}

function tanker_movement()
{
	e_linkto = GetEnt( "tanker_linkto", "targetname" );
	e_tanker = GetEnt( "dock_assault_tanker", "targetname" );
	a_e_orgs = GetEntArray( "tanker_ride_linkto", "targetname" );
	e_hendricks_linkto = GetEnt( "tanker_ride_linkto_hendricks", "targetname" );
	
	e_tanker thread tanker_at_subway();
	
	foreach( e_org in a_e_orgs )
	{
		e_org LinkTo( e_tanker );
	}
	
	e_hendricks_linkto LinkTo( e_tanker );
	
	e_linkto thread tanker_smash();
	
	e_tanker LinkTo( e_linkto );
	
	level endon( "tanker_go" );
	
	while( 1 )
	{
		e_linkto RotateRoll( -5, 0.5 );
		e_linkto waittill( "rotatedone" );
		e_linkto RotateRoll( 5, 2 );
		e_linkto waittill( "rotatedone" );
	}
}

function tanker_at_subway()  //self = tanker
{
	level flag::wait_till( "tanker_ride_done" );
	
	wait 0.1;  //wait a bit for player to unlink
	
	self Unlink();
	
	s_goal = struct::get( "tanker_subway_pos" );
	
	self MoveTo( s_goal.origin, 0.05 );
}

function tanker_smash()  //self = entity tanker is linked to
{
	v_rot = self.angles;
	
	v_pos1 = struct::get( "boat_pos1", "targetname" ).origin;
	v_pos2 = struct::get( "boat_pos2", "targetname" ).origin;
	
	b_players_anchored = false;
	
	level flag::wait_till( "tanker_smash" );
	
	a_t_boundary = GetEntArray( "ocean_boundary", "targetname" );
	foreach ( t_boundary in a_t_boundary )
	{
		t_boundary Delete();
	}
	
	level thread barge_wave();
	
	level flag::set( "tanker_go" );
	
	self RotateTo( v_rot, 1 );
	self waittill( "rotatedone" );
	
	a_e_orgs = GetEntArray( "tanker_ride_linkto", "targetname" );
	a_e_pos = GetEntArray( "tanker_ready_pos", "targetname" );
	a_s_subway = struct::get_array( "player_subway_pos" );
	
	foreach( player in level.players )
	{
		player.e_org = a_e_orgs[ player GetEntityNumber() ];
		player.e_pos = a_e_pos[ player GetEntityNumber() ];
		player.s_subway = a_s_subway[ player GetEntityNumber() ];
		player thread player_tanker_anchor();
	}
	
	level.ai_hendricks thread vo_hendricks_boatride();
	
	level flag::wait_till( "tanker_face" );
	
	self RotateYaw( -50, 3 );
	
	level.ai_hendricks thread hendricks_boatride();
	
	//wait 2;  //wait a bit for Hendricks to point out the ship
	
	self waittill( "rotatedone" );
	
	self MoveTo( v_pos1, 7 );
	
	wait 5;  //wait until ship gets closer
	
	level flag::set( "tanker_hit" );
	
	self MoveTo( v_pos2, 15 );
	
	wait 2;  //allow time for collision to register
	
	level flag::set( "tanker_ride" );  //kills player if he's not anchored
	
	wait 0.1;  //give time for players to anchor
	
	foreach( player in level.players )
	{
		if ( player.is_anchored )
		{
			b_players_anchored = true;
		}
	}
	
	if ( b_players_anchored )
	{
		self waittill( "movedone" );
	
		level flag::set( "tanker_ride_done" );
	}
	else
	{
		util::missionFailedWrapper( "You Failed to Anchor onto the Ship" );
	}
	
	level notify( "stop_cargo_rocker" );
}

function hendricks_boatride()  //self = hendricks
{
	level flag::wait_till( "tanker_ride" );
	
	e_hendricks_linkto = GetEnt( "tanker_ride_linkto_hendricks", "targetname" );
	
	level.ai_hendricks ForceTeleport( e_hendricks_linkto.origin, e_hendricks_linkto.angles );
	level.ai_hendricks Linkto( e_hendricks_linkto );
	
	level flag::wait_till( "tanker_ride_done" );
	
	e_hendricks_linkto Unlink();
		
	level.ai_hendricks Unlink();
	level.ai_hendricks skipto::teleport_single_ai( struct::get( "objective_subway_ai" ) );
	level.ai_hendricks colors::enable();
}

function vo_hendricks_boatride()  //self = Hendricks
{
	level.ai_hendricks dialog::say( "The ship just broke loose!  It's headed this way!" );
	level.ai_hendricks dialog::say( "Get to the front of the wheelhouse!" );
	level.ai_hendricks thread dialog::say( "We have to jump for it!" );
	
	level flag::wait_till( "tanker_hit" );
	
	level.ai_hendricks thread dialog::say( "Jump!" );
	
	util::screen_message_create( &"CP_MI_SING_BLACKSTATION_JUMP_SHIP", undefined, undefined, 32, 3 );
}

function tanker_ride_waypoint()
{
	level flag::wait_till( "roof_fly" );
	
	e_waypt = GetEnt( "waypt_tanker_smash", "targetname" );
	
	objectives::set( "cp_standard_breadcrumb" , e_waypt );
	
	level flag::wait_till( "tanker_hit" );
	
	objectives::complete( "cp_standard_breadcrumb" , e_waypt );
}

function player_tanker_anchor()  //self = player
{
	self endon( "death" );
	
	self notify( "end_anchor" );  //end anchoring mechanic for tanker ride
	
	//self SetOrigin( self.e_pos.origin );
	//self SetPlayerAngles( self.e_pos.angles );
	//self PlayerLinkTo( self.e_pos, "tag_origin", 1, 10, 10, 30, 10 );
	
	level flag::wait_till( "tanker_hit" );
	
	//self Unlink();
	
	self PlayRumbleOnEntity( "artillery_rumble" );
	Earthquake( 1, 1.5, self.origin, 100 );
	
	self thread player_anchor_tanker();
	
	level flag::wait_till( "tanker_ride" );  //player has until tanker ride starts to anchor himself to the tanker
	
	if ( self.is_anchored )
	{
		self EnableInvulnerability();
		
		self thread player_tanker_ride();
		
		level flag::wait_till( "tanker_ride_done" );
	
		self Unlink();
		self.is_anchored = false;
		
		self SetOrigin( self.s_subway.origin );
		self SetPlayerAngles( self.s_subway.angles );
		
		self PlayRumbleOnEntity( "artillery_rumble" );
		Earthquake( 1.3, 2, self.origin, 1000 );
		
		self thread blackstation_utility::player_anchor();  //re-enable anchor mechanic
		
		wait 2;  //give time for player to hit ground
		
		self DisableInvulnerability();
	}
	else
	{
		self DoDamage( self.health, self.origin );
	}
}

function player_tanker_ride()  //self = player
{
	self endon( "death" );
	
	while( !level flag::get( "tanker_ride_done" ) )
	{
		self PlayRumbleOnEntity( "artillery_rumble" );
		Earthquake( 1, 1.5, self.origin, 100 );
		
		wait 2;
	}
}

function player_anchor_tanker()
{
	self endon( "death" );
	
	self.is_anchored = false;
	
	while( !level flag::get( "tanker_ride" ) )
	{
		if ( self JumpButtonPressed() )
		{
			self PlayerLinkTo( self.e_org, "tag_origin", 1, 45, 15, 45, 30 );
			
			self.is_anchored = true;
			
			while( self JumpButtonPressed() )
			{
				{wait(.05);};	
			}
			
			break;
		}
		
		{wait(.05);};
	}	
}

function barge_wave()
{
	//wave hits barge and wheelhouse breaks apart
	a_e_barge_roof = GetEntArray( "barge_roof", "targetname" );
	e_linkto = GetEnt( "barge_roof_linkto", "targetname" );
		
	Earthquake( 1, 1.5, a_e_barge_roof[0].origin, 1000 );
	
	e_wheel = GetEnt( "barge_wheel", "targetname" );
	e_wheel Delete();
	
	foreach( e_barge_roof in a_e_barge_roof )
	{
		e_barge_roof Unlink();
		e_barge_roof LinkTo( e_linkto );
	}
	
	level flag::wait_till( "roof_fly" );
	
	wait 0.5;  //allow fx to start first
	
	e_linkto RotateRoll( -100, 2 );
	e_linkto MoveTo( e_linkto.origin + ( 0, 2000, 300 ), 4 );
	e_linkto waittill( "movedone" );
	e_linkto Delete();
	
	foreach( e_barge_roof in a_e_barge_roof )
	{
		e_barge_roof Delete();
	}
}

function debris_toilet_launch()
{
	trigger::wait_till( "trigger_toilet" );
	
	e_toilet = GetEnt( "debris_toilet", "targetname" );
	
	e_toilet thread blackstation_utility::debris_rotate();
	e_toilet thread blackstation_utility::check_player_hit();
	
	e_toilet MoveTo( e_toilet.origin + ( 0, 6000, 200 ), 8 );
	e_toilet waittill( "movedone" );
	
	e_toilet Delete();
}

function debris_car_launch()  //TODO - replace with FXAnim
{
	e_car = GetEnt( "debris_car", "targetname" );
	s_start = struct::get( "debris_car_start" );
	s_mid = struct::get( "debris_car_mid" );
	s_end = struct::get( "debris_car_end" );
	
	level thread debris_junk_launch( "p7_debris_junkyard_scrap_pile_01", "debris_junk" );
	level thread debris_junk_launch( "veh_t7_mil_boat_fan", "debris_boat" );
	
	e_car MoveTo( s_start.origin, 0.5 );
	e_car waittill( "movedone" );
	Earthquake( 0.5, 1, e_car.origin, 600 );
	
	e_car RotatePitch( -45, 1 );
	e_car MoveTo( s_mid.origin, 1 );
	e_car waittill( "movedone" );
	Earthquake( 0.5, 1, e_car.origin, 600 );
	
	e_car RotatePitch( -180, 1 );
	e_car MoveTo( s_end.origin, 1 );
	e_car waittill( "movedone" );
	Earthquake( 0.5, 1, e_car.origin, 1600 );
	
	e_car Delete();
}

function debris_junk_launch( str_model, str_type )
{
	s_start = struct::get( str_type + "_start" );
	s_mid = struct::get( str_type + "_mid" );
	s_end = struct::get( str_type + "_end" );
	
	e_debris = Spawn( "script_model", s_start.origin );
	e_debris SetModel( str_model );
	
	e_debris RotatePitch( RandomIntRange( -45, -30 ), 1 );
	e_debris MoveTo( s_mid.origin, 1 );
	e_debris waittill( "movedone" );
	
	e_debris RotatePitch( RandomIntRange( -120, -45 ), 1 );
	e_debris MoveTo( s_end.origin, 1 );
	e_debris waittill( "movedone" );
		
	e_debris Delete();
}
