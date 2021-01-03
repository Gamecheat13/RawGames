#using scripts\codescripts\struct;

#using scripts\cp\_dialog;
#using scripts\cp\_objectives;
#using scripts\cp\_skipto;
#using scripts\cp\_spawn_manager;
#using scripts\cp\_util;

#using scripts\cp\cp_mi_sing_sgen;
#using scripts\cp\cp_mi_sing_sgen_util;

#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\colors_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_ai_shared;
#using scripts\shared\vehicle_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       



function skipto_underwater_rail_init( str_objective, b_starting )
{
	spawner::add_spawn_function_group( "underwater_rail_bot", "script_noteworthy", &init_rail_bot );

	level.ai_hendricks = util::get_hero( "hendricks" );
	level.ai_hendricks colors::set_force_color( "r" );

	if ( b_starting )
	{
		level clientfield::set( "w_underwater_state", 1 );
		spawner::add_global_spawn_function( "axis", &sgen_util::robot_underwater_callback );

		level scene::init( "hendricks_door_explosion" );

		objectives::set( "cp_level_sgen_escape_sgen" );
		
		t_trigger = GetEnt( "uw_rail_sequence_start", "targetname" );

		level scene::skipto_end( "cin_sgen_23_01_underwater_battle_vign_swim_hendricks_traverse_room", level.ai_hendricks );
		
		sgen::wait_for_all_players_to_spawn();
	}

	SetDvar( "player_swimTime", 5000 );

	level thread vo();
	
	objective_trigger = GetEnt( "uw_rail_sequence_start", "targetname" );

	objectives::set( "cp_level_sgen_use_3d", objective_trigger.origin + ( 0, 0, 16 ) );

	hendricks_blow_wall();

	spawn_manager::kill( "uw_battle_spawnmanager", true );
	
	objectives::complete( "cp_level_sgen_follow_hendricks", level.ai_hendricks );

	align_struct = struct::get( "hendricks_water_ride_align", "targetname" );
	align_struct thread scene::init( "cin_sgen_24_01_ride_vign_waterride" );

	objectives::complete( "cp_level_sgen_use_3d" );

	foreach( player in level.players )
	{
		player WalkUnderwater( false );
		player SetPlayerGravity( 130 );
	}

	SetJumpHeight( 39 );

	// Cleanup From UW Battle
	array::run_all( GetEntArray( "exhaust_fan", "targetname" ), &Delete );
	exploder::delete_exploder_on_clients( "underwater_battle_fan_vortex" );

	//start water ride section.
	a_trigger_debris = GetEntArray( "water_ride_debris_trigger", "targetname" );
	array::thread_all( a_trigger_debris, &setup_debris );

	a_trigger_split = GetEntArray( "uw_rail_split_trigger", "targetname" );
	array::thread_all( a_trigger_split, &handle_split_off );

	a_t_static_hurt = GetEntArray( "water_ride_static_hurt_trigger", "targetname" );
	array::thread_all( a_t_static_hurt, &static_hurt );

	level thread player_rail_sequence_start();
}

function skipto_underwater_rail_done( str_objective, b_starting, b_direct, player )
{

}

function hendricks_blow_wall()
{
	// TODO: Create unique align node once Radiant runs better + update GDT
	s_align_start = struct::get_array( "dark_battle_align_2", "targetname" )[ 1 ];
	s_align_end = struct::get_array( "hendricks_ride_align", "targetname" )[ 3 ];

	level flag::wait_till( "all_players_spawned" );

	t_trigger = GetEnt( "uw_rail_sequence_start", "targetname" );
	s_gather = struct::get( t_trigger.target, "targetname" );
	
	objectives::complete( "cp_level_sgen_breadcrumb" );
	objectives::set( "cp_level_sgen_gather", s_gather );
	
	t_trigger sgen_util::gather_point_wait();

	level notify( "gather_completed" );
	
	s_align_start scene::play( "cin_sgen_23_02_blow_door_vign_start", level.ai_hendricks );
	s_align_start thread scene::init( "cin_sgen_23_02_blow_door_vign_end", level.ai_hendricks );

	t_trigger sgen_util::gather_point_wait();

	objectives::complete( "cp_level_sgen_gather" );
	
	e_charge = GetEnt( "blow_wall_charge", "targetname" );
	PlayFX( level._effect[ "fake_depth_charge_explosion" ], e_charge.origin );//TODO - this needs to get notetracked

	level thread scene::play( "hendricks_door_explosion" );
	wait .1;//TODO - this transition needs to get notetracked
	foreach ( n_index, player in level.players )
	{
		player thread player_rail_sequence_init( n_index );
	}
	s_align_end scene::play( "cin_sgen_23_02_blow_door_vign_end", level.ai_hendricks );
}

function vo()
{
	// TODO: How are we addressing Hendricks over comms underwater?
	
	level.ai_hendricks dialog::remote( "hend_gather_on_my_positio_0", .2 ); // Gather on my position, I'm going to blow the door!
	
	level.ai_hendricks thread do_nag();
}

// Self is AI
function do_nag()
{
	level endon( "gather_completed" );
	
	wait RandomFloatRange( 8, 13 );

	level.ai_hendricks dialog::remote( "hend_this_place_will_bury_0" ); // This place will bury us if we don’t move, get to my position!

	wait RandomFloatRange( 8, 13 );

	level.ai_hendricks dialog::remote( "hend_regroup_on_me_our_o_0" ); // Regroup on me! Our O2 Reserves won’t last much longer! 
}

function player_rail_sequence_init( n_index )
{
	//Slight pause before player gets sucked in so Hendricks goes first
	wait .1;
	self.animViewUnlock = false;
	self.animInputUnlock = true;
	self.n_ride_position = n_index;
	self thread scene::play( "cin_sgen_24_01_ride_vign_body_player_flail_" + self.n_ride_position, self );

	a_v_spawner = GetEntArray( "player_rail_vehicle", "targetname" );
	v_spawner = a_v_spawner[ n_index ];

	path_start = GetVehicleNode( v_spawner.target, "targetname" );
	self.v_rail_vehicle = spawner::simple_spawn_single( v_spawner );

	wait .1;//Wait for scene to setup

	mdl_tmp_link = util::spawn_model( "tag_origin", self.origin, self.angles );
	self PlayerLinkToDelta( mdl_tmp_link, undefined, 0, 0, 0, 0, 0, 0, 0 );

	//Move player to their start node
	mdl_tmp_link MoveTo( path_start.origin, 1 );
	mdl_tmp_link RotateTo( path_start.angles, 1 );
	mdl_tmp_link waittill( "movedone" );

	self.v_rail_vehicle.origin = self.origin;
	self Unlink();

	self PlayerLinkToDelta( self.v_rail_vehicle, "origin_animate_jnt", 0.5, 30, 30, 30, 30 );
	self.v_rail_vehicle vehicle::get_on_path( path_start );

	mdl_tmp_link Delete();
}

function player_rail_sequence_start()
{
	sndEnt = Spawn( "script_origin", ( 0,0,0 ) );
	//Alias below moved to fxanim "p7_fxanim_cp_sgen_door_hendricks_explosion_left_anim"
	//sndEnt PlaySound( "evt_sgen_waterrail_start" );
	sndEnt PlayLoopSound( "evt_sgen_waterrail_loop", 1.5 );

	foreach ( n_index, player in level.players )
	{
		player thread player_rail_sequence( n_index );

		player util::magic_bullet_shield();
		//player setclientfocallength( 500 );
		player clientfield::set_to_player( "tp_water_sheeting", 1 );
	}

	wait .5;//Time fighting initial surge

	align_struct = struct::get( "hendricks_water_ride_align", "targetname" );
	align_struct scene::play( "cin_sgen_24_01_ride_vign_waterride" );

	wait 13;//TODO what is this for?

	//level.players[ 0 ] thread dialog::say( "A.M.S. status: increased oxygen use levels now at...time to D.P. 4 min." ); // Rachel

	player.v_rail_vehicle waittill( "rail_over" );

	foreach ( n_index, player in level.players )
	{
		player util::stop_magic_bullet_shield();
		player clientfield::set_to_player( "tp_water_sheeting", 0 );
	}

	skipto::objective_completed( "underwater_rail" );
	//v_player_v_rail_vehicle.drivepath = true;

	sndEnt Delete();
}

function setup_debris()
{
	//self = trigger
	t_hurt_trigger = GetEnt( self.target, "targetname" );
	m_debris_model = GetEnt( t_hurt_trigger.target, "targetname" );
	s_destination = struct::get( m_debris_model.target, "targetname" );

	t_hurt_trigger EnableLinkTo();
	t_hurt_trigger LinkTo( m_debris_model );
	t_hurt_trigger thread debris_impact();

	self waittill( "trigger" );
	m_debris_model RotateTo( ( 180, 180, 180 ), 5 );

	if ( IsDefined( s_destination.script_int ) )
	{
		m_debris_model MoveTo( s_destination.origin, s_destination.script_int );
	}
	else
	{
		m_debris_model MoveTo( s_destination.origin, 5 );
	}

	m_debris_model waittill( "movedone" );

	if ( IsDefined( s_destination.target ) )
	{
		e_next_dest = struct::get( s_destination.target, "targetname" );
		if ( IsDefined( e_next_dest.script_int ) )
		{
			m_debris_model MoveTo( e_next_dest.origin, e_next_dest.script_int );
		}
		else
		{
			m_debris_model MoveTo( e_next_dest.origin, 5 );
		}
	}

	m_debris_model waittill( "movedone" );
	t_hurt_trigger notify( "stop" );
	m_debris_model Delete();
}

function debris_impact()
{
	self endon( "stop" );

	a_players_hit = [];

	while ( true )
	{
		self waittill( "trigger", e_player );

		if ( !IsInArray( a_players_hit, e_player ) && IsPlayer( e_player ) )
		{
			if ( !isdefined( a_players_hit ) ) a_players_hit = []; else if ( !IsArray( a_players_hit ) ) a_players_hit = array( a_players_hit ); a_players_hit[a_players_hit.size]=e_player;

			e_player thread handle_impact( 0.5, 1.0 );
		}
	}
}

function static_hurt()
{
	level endon( "underwater_rail_terminate" );

	while ( true )
	{
		self waittill( "trigger", e_player );

		if ( IsPlayer( e_player ) && ( !IsDefined( e_player.n_uw_static_hurt_time ) || ( GetTime() - e_player.n_uw_static_hurt_time ) > 2000 ) )
		{
			e_player.n_uw_static_hurt_time = GetTime();

			e_player thread handle_impact( 1.0, 0.75 );
		}
	}
}

function play_current_fx()
{
	self endon( "rail_over" );

	while ( true )
	{
		PlayFXOnTag( level._effect[ "current_effect" ], self, "tag_origin" );
		wait 0.1;
	}
}

function handle_split_off()
{
	path_start = GetVehicleNode( self.target, "targetname" );

	while ( true )
	{
		self waittill( "trigger", player );

		if ( !( isdefined( player.v_rail_vehicle.locked_offset ) && player.v_rail_vehicle.locked_offset ) )
		{
			player notify( "switch_rail" );
			player.v_rail_vehicle vehicle::get_on_and_go_path( path_start );
			player.v_rail_vehicle notify( "rail_over" );
			player thread scene::stop( "cin_sgen_24_01_ride_vign_body_player_flail_" + player.n_ride_position );
			player UnLink();
			skipto::objective_completed( "underwater_rail" );

			break;
		}
	}
}

function player_rail_sequence( wait_time )
{
	self endon( "disconnect" );
	self endon( "switch_rail" );

	self.v_rail_vehicle thread player_rail_control( self );
	self.v_rail_vehicle thread play_current_fx();

	wait .5 + 1 + wait_time;

	self.v_rail_vehicle vehicle::go_path();

	self.v_rail_vehicle notify( "rail_over" );
	self.animViewUnlock = true;
	self.animInputUnlock = false;
	self thread scene::stop( "cin_sgen_24_01_ride_vign_body_player_flail_" + self.n_ride_position );
	self StopAnimScripted();//HACK - stop call is not stopping the scene for some reason, needs support
	self UnLink();
	self sgen_util::refill_ammo();
}

function player_rail_control( player )
{
	self endon( "disconnect" );
	self endon( "rail_over" );

	const LEFT_MAGNITUDE = -0.5;
	const RIGHT_MAGNITUDE = 0.5;

	self.y_offset = 0;
	self.z_offset = 0;

	while ( true )
	{

		v_stick = player GetNormalizedMovement();
		n_left = v_stick[ 1 ];
		n_up = v_stick[ 0 ];

		if ( !( isdefined( self.locked_offset ) && self.locked_offset ) )
		{
			if ( n_left < LEFT_MAGNITUDE )
			{
				if ( self.y_offset > -50 )
				{
					self.y_offset -= 10;
				}

			}
			else if ( n_left > RIGHT_MAGNITUDE )
			{
				if ( self.y_offset < 50 )
				{
					self.y_offset += 10;
				}
			}
			else
			{
				if ( self.y_offset != 0 )
				{
					self.y_offset += ( self.y_offset > 0 ? -5 : 5 );
				}
			}

			if ( n_up < LEFT_MAGNITUDE )
			{
				if ( self.z_offset > -10 )
				{
					self.z_offset -= 10;
				}

			}
			else if ( n_up > RIGHT_MAGNITUDE )
			{
				if ( self.z_offset < 10 )
				{
					self.z_offset += 10;
				}
			}
			else
			{
				if ( self.z_offset != 0 )
				{
					self.z_offset += ( self.z_offset > 0 ? -5 : 5 );
				}
			}
		}

		/#
		PrintLn( self.y_offset );
		#/

		self PathFixedOffset( ( 0, self.y_offset, self.z_offset ) );

		wait 0.05;
	}
}

function handle_impact( n_intensity, n_time )
{
	self endon( "disconnect" );

	self.v_rail_vehicle.locked_offset = true;

	self.v_rail_vehicle.y_offset *= -1;
	self.v_rail_vehicle.z_offset *= -1;

	Earthquake( n_intensity, n_time, self.origin, 256 );

	self PlayRumbleOnEntity( "damage_heavy" );
	
	self playlocalsound( "evt_waterride_impact" );

	wait n_time * 0.25;

	self.v_rail_vehicle.locked_offset = false;
}

//self = robot
function init_rail_bot()
{
	self.script_accuracy = .1;
}
