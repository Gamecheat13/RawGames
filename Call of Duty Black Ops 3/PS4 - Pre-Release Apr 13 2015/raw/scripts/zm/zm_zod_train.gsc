                                                                                                                                                                                                                                                                                                                                                                                                                 	                                                                                                                                                                          	                                                                                         	                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                                                               	                                                                                                                                                                                                                                              	                                                                                                                                           	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   	                                                                                                                       	   	                                                                                                                                                                                                                                                                                                                         	                                                                                                                                                                                                                                      
    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\codescripts\struct;

#using scripts\shared\ai\zombie_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#using scripts\shared\ai\zombie_utility;

#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_net;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_zonemgr;
#using scripts\zm\zm_zod_util;









#namespace zm_train;

#precache( "triggerstring", "ZM_ZOD_TRAIN_POWER_PCT" );
#precache( "triggerstring", "ZM_ZOD_TRAIN_USE" );
#precache( "triggerstring", "ZM_ZOD_TRAIN_USE_FREE" );
#precache( "triggerstring", "ZM_ZOD_TRAIN_NOPOWER" );
#precache( "triggerstring", "ZM_ZOD_TRAIN_COOLDOWN" );
#precache( "triggerstring", "ZM_ZOD_TRAIN_CALL" );
#precache( "triggerstring", "ZM_ZOD_TRAIN_MOVING" );

#precache( "fx", "light/fx_light_sat_relay_yellow" );

function autoexec __init__sytem__() {     system::register("zm_train",&__init__,&__main__,undefined);    }

function onPlayerConnect()
{
	self.on_train = false;
}

function __init__()
{
	callback::on_connect( &onPlayerConnect );
	zm_zod_util::on_zombie_killed( &remove_dead_zombie );
	zm_zod_util::add_zod_zombie_spawn_func( &zombie_init );
	level.enemy_location_override_func = &enemy_location_override;
	
	/#
		thread train_devgui();
	#/
}

function __main__()
{
	e_train = GetEnt( "zod_train", "targetname" );
	level.o_zod_train = new cZmTrain();
	[[level.o_zod_train]]->initialize( e_train );
	
	level thread autosend_train();
}

function zombie_init()
{
	self.locked_in_train = false;
}

function autosend_train()
{
	level flag::wait_till( "connect_start_to_junction" );
	[[level.o_zod_train]]->send_train();
}

class cZmTrain
{
	var m_e_train;
	var m_s_trigger;
	var m_e_volume;
	var m_b_facing_forward;
	var m_b_free;
	var m_n_power;
	var m_b_incoming;
	
	var m_a_stations;
	var m_a_doors;
	var m_str_station;
	var m_str_destination;
	
	var m_a_zombies_locked_in;
	var m_n_last_jumper_time;
	
	var m_a_jumptags;
	
	constructor()
	{
		m_e_train = undefined;
		m_e_volume = undefined;
		m_str_station = undefined;
		m_b_facing_forward = true;
		m_b_free = false;
		
		m_a_stations = [];
		m_a_doors = [];
		
		m_a_zombies_locked_in = [];
		
		m_n_power = 0;
		m_n_last_jumper_time = 0;
		m_b_incoming = false;
		
		m_a_jumptags = [];
		a_names = array( "tag_enter_back_top", "tag_enter_front_top", "tag_enter_left_top", "tag_enter_right_top" );
		a_anims = array( "ai_zombie_zod_train_win_trav_from_roof_b", "ai_zombie_zod_train_win_trav_from_roof_f", "ai_zombie_zod_train_win_trav_from_roof_l", "ai_zombie_zod_train_win_trav_from_roof_r" );
		assert( a_names.size == a_anims.size );
		for ( i = 0; i < a_names.size; i++ )
		{
			str_name = a_names[i];
			str_anim = a_anims[i];
			m_a_jumptags[ str_name ] = SpawnStruct();
			s_entrance = m_a_jumptags[ str_name ];
			s_entrance.str_tag = str_name;
			s_entrance.str_anim = str_anim;
			s_entrance.occupied = false;
		}
	}
	
	function debug_draw_paths()
	{
		/#
		do
		{
			n_debug = GetDvarInt( "train_debug" );
			wait 1.0;
		}
		while ( !isdefined( n_debug ) || n_debug <= 0 );
		
		while( 1 )
		{
			a_keys = GetArrayKeys( m_a_stations );
			for ( key_num = 0; key_num < m_a_stations.size; key_num++ )
			{
				j = a_keys[ key_num ];
				node_set = m_a_stations[j].nodes;
				
				for( i=0; i<node_set.size; i++ )
				{
					node = node_set[i];
		
					node_pos = node.origin + ( 0, 0, -95 );
					
					debugstar( node_pos, 1, (1,0,0) );	
					
					if( IsDefined( node.target ) )
					{
						node_target = GetVehicleNode( node.target, "targetname" );		
						node_target_pos = node_target.origin + ( 0, 0, -70 );
						line( node_pos, node_target_pos, (0,1,0), false, 1 );
						debugstar( node_target_pos, 1, (0,1,0) );	
					}
					
					if( IsDefined( node.target2 ) )
					{
						node_target2 = GetVehicleNode( node.target2, "targetname" );				
						node_target2_pos = node_target2.origin + ( 0, 0, -120 );
						line( node_pos, node_target2_pos, (0,0,1), false, 1 );
						debugstar( node_target2_pos, 1, (0,0,1) );	
					}
				}				
			}
			
			a_zombies = GetAITeamArray( level.zombie_team );
			foreach( ai in a_zombies )
			{
				if ( ( isdefined( ai.locked_in_train ) && ai.locked_in_train ) )
				{
					Print3d(ai.origin + (0,0,100), "On Train (" + m_a_zombies_locked_in.size + ")", (0,255,0), 1);
				}
			}
			
			{wait(.05);};
		}
		#/
	}
	
	function switch_path_direction( all_nodes, direction )
	{
		for( i=0; i<all_nodes.size; i++ )
		{
			prev_target = all_nodes[i].target;
			all_nodes[i].target =  all_nodes[i].target2;
			all_nodes[i].target2 = prev_target;
		}
		return !direction;
	}
	
	function enable_train_switches( b_enabled )
	{
		if ( b_enabled )
		{
			self flag::set( "switches_enabled" );
		}
		else
		{
			self flag::clear( "switches_enabled" );
		}
	}
	
	function get_current_destination()
	{
		if ( !is_moving() )
		{
			return m_str_station;
		}
		else
		{
			if ( !isdefined( m_str_destination ) )
			{
				if ( m_a_stations[ m_str_station ].left_path_active )
				{
					return m_a_stations[ m_str_station ].left_path;
				}
				else
				{
					return m_a_stations[ m_str_station ].right_path;
				}
			}
			
			// Destination is locked in.
			else
			{
				return m_str_destination;
			}
		}
	}
	
	function get_station_pos( str_station )
	{
		return m_a_stations[ str_station ].origin;
	}
	
	function get_destination_pos()
	{
		str_dest = get_current_destination();
		return get_station_pos( str_dest );
	}
	
	function watch_node_parameters()
	{
		m_e_train endon( "docked_in_station" );
		while ( true )
		{
			m_e_train waittill( "reached_node", nd );
			if ( isdefined( nd.script_parameters ) )
			{
				switch( nd.script_parameters )
				{
					case "arrival_brakes":
						if ( m_b_incoming )
						{
							m_e_train playsound( "evt_train_stop" );
						}
						break;
					case "arrival_bell":
						if ( m_b_incoming )
						{
							str_dest = get_current_destination();
							e_callbox = m_a_stations[str_dest].callbox;
							e_callbox playsound( "evt_train_station_bell" );
						}
						break;
					default:
						AssertMsg( "Unknown train node parameter: " + nd.script_parameters );
						break;
				}
			}
		}
	}
		
	function move()
	{		
		m_b_incoming = false;
		m_str_destination = undefined;
		m_e_train.backwards = !m_e_train.backwards;
		str_start = m_str_station;
		str_left = m_a_stations[str_start].left_path;
		str_right = m_a_stations[str_start].right_path;
		                    
		// If you're seeing a jarring motion in the junction, try increasing this value.		
		const near_node_dist_sq = 122500; // 350 squared
		
		//Make sure all paths are in correct direction based on where the train is starting from
		// str_start 				--> needs to point towards junction
		// str_left + str_right 	--> need to point away from junction
		if( m_a_stations[str_start].path_toward_junction == false )
		{
			m_e_train flip180();
			m_a_stations[str_start].path_toward_junction = switch_path_direction( m_a_stations[str_start].nodes, m_a_stations[str_start].path_toward_junction );
			m_e_train switchstartnode( m_a_stations[str_start].start_node, m_a_stations[str_start].junction_node );
		}
		
		if( m_a_stations[str_left].path_toward_junction == true )
		{
			m_a_stations[str_left].path_toward_junction = switch_path_direction( m_a_stations[str_left].nodes, m_a_stations[str_left].path_toward_junction );
			m_e_train switchstartnode( m_a_stations[str_left].start_node, m_a_stations[str_left].junction_node );
		}
		
		if( m_a_stations[str_right].path_toward_junction == true )
		{
			m_a_stations[str_right].path_toward_junction = switch_path_direction( m_a_stations[str_right].nodes, m_a_stations[str_right].path_toward_junction );
			m_e_train switchstartnode( m_a_stations[str_right].start_node, m_a_stations[str_right].junction_node );
		}
		
		str_dest = get_current_destination();
		str_depart = m_a_stations[ str_dest ].audio_depart;
		m_e_train playsound( str_depart );
		
		thread watch_node_parameters();
		
		//Now recalculate for all paths
		m_e_train recalcsplinepaths();		
		m_e_train AttachPath( m_a_stations[str_start].start_node );
		m_e_train StartPath();
		
		// Wait till we're near the junction.
		while ( Distance2DSquared( m_e_train.origin, m_a_stations[str_start].junction_node.origin ) > near_node_dist_sq )
		{
			util::wait_network_frame();
		}
		
		enable_train_switches( false );
		util::delay( 20.0, undefined, &enable_train_switches, true );
		
		// Select a path based on the state of the switch.
		str_chosen_path = str_left;
		if ( !m_a_stations[ str_start ].left_path_active )
		{
			str_chosen_path = str_right;
		}
		
		which_way = m_a_stations[str_chosen_path].junction_node;
		m_e_train SetSwitchNode( m_a_stations[str_start].junction_node, m_a_stations[str_chosen_path].junction_node );
		
		m_str_destination = str_chosen_path;
		m_b_incoming = true;
		
		m_e_train waittill( "reached_end_node" );
		
		m_b_facing_forward = !m_b_facing_forward;
		m_str_station = str_chosen_path;
		
		m_str_destination = undefined;
		m_e_train notify( "docked_in_station", m_str_station );
		
		str_arrive = m_a_stations[ m_str_station ].audio_arrive;
		m_e_train playsound( str_arrive );
	}
	
	// Directs all relevant switches toward the specified destination.
	//
	function direct_all_switches( str_destination )
	{
		foreach( s_station in m_a_stations )
		{
			e_switch = s_station.path_switch_left;
			str_left = m_a_stations[e_switch.script_string].left_path;
			str_right = m_a_stations[e_switch.script_string].right_path;
			left_path_active = m_a_stations[e_switch.script_string].left_path_active;
			if ( (!left_path_active && str_left == str_destination) || (left_path_active && str_right == str_destination) )
			{
				// Activate the switch.
				e_switch notify( "force_switch" );
			}
		}
	}
	
	function initialize( e_train )
	{
		self flag::init( "moving", false );
		self flag::init( "cooldown", false );
		self flag::init( "fully_powered", false );
		self flag::init( "switches_enabled", true );

		e_train.team = "spectator";
		
		m_a_stations = [];
		
		a_path_nodes = GetNodeArray( "train_pathnode", "targetname" );
		foreach( nd in a_path_nodes )
		{
			m_a_stations[nd.script_string] = SpawnStruct();
			m_a_stations[nd.script_string].path_node = nd;
			m_a_stations[nd.script_string].origin = nd.origin;
			m_a_stations[nd.script_string].angles = nd.angles;
			m_a_stations[nd.script_string].station_id = nd.script_string;
			m_a_stations[nd.script_string].door_side = nd.script_parameters;
		}
		
		// Slums
		//
		m_a_stations["a"].left_path = "c";
		m_a_stations["a"].right_path = "b";
		m_a_stations["a"].audio_divert = "vox_tanc_divert_slums_1";
		m_a_stations["a"].audio_depart = "vox_tanc_depart_slums_1";
		m_a_stations["a"].audio_arrive = "vox_tanc_board_canal_1";
		
		// Theater
		m_a_stations["b"].left_path = "a";
		m_a_stations["b"].right_path = "c";
		m_a_stations["b"].audio_divert = "vox_tanc_divert_theater_1";
		m_a_stations["b"].audio_depart = "vox_tanc_depart_theater_1";
		m_a_stations["b"].audio_arrive = "vox_tanc_board_slums_1";
		
		// Canals
		m_a_stations["c"].left_path = "b";
		m_a_stations["c"].right_path = "a";
		m_a_stations["c"].audio_divert = "vox_tanc_divert_canal_1";
		m_a_stations["c"].audio_depart = "vox_tanc_depart_canal_1";
		m_a_stations["c"].audio_arrive = "vox_tanc_board_theater_1";
		
		a_start_nodes = GetVehicleNodeArray( "train_start", "script_noteworthy" );
		foreach( nd in a_start_nodes )
		{
			m_a_stations[nd.script_string].start_node = nd;
		}
		
		a_destination_signs_left = GetEntArray( "train_destination_sign_left", "targetname" );
		foreach( e_sign in a_destination_signs_left )
		{
			m_a_stations[e_sign.script_string].path_destination_sign_left = e_sign;
		}
		
		a_destination_signs_right = GetEntArray( "train_destination_sign_right", "targetname" );
		foreach( e_sign in a_destination_signs_right )
		{
			m_a_stations[e_sign.script_string].path_destination_sign_right = e_sign;
		}
		
		a_switch_lights = GetEntArray( "destination_light", "script_noteworthy" );
		foreach( e_light in a_switch_lights )
		{
			m_a_stations[e_light.script_string].path_destination_light = e_light;
		}
		
		a_light_anchors = GetEntArray( "destination_light_anchor", "targetname" );
		foreach( e_anchor in a_light_anchors )
		{
			m_a_stations[e_anchor.script_string].path_destination_light_anchor = e_anchor;
		}
		
		a_switches_left = GetEntArray( "switch_train_left", "targetname" );
		foreach( e_switch in a_switches_left )
		{
			m_a_stations[e_switch.script_string].path_switch_left = e_switch;
		}
		
		a_switches_right = GetEntArray( "switch_train_right", "targetname" );
		foreach( e_switch in a_switches_right )
		{
			m_a_stations[e_switch.script_string].path_switch_right = e_switch;
			thread run_switch( e_switch.script_string );
		}
		
		
		// Store all the nodes.
		a_keys = GetArrayKeys( m_a_stations );
		for ( i = 0; i < a_keys.size; i++ )
		{
			str_key = a_keys[i];
			nd_next = m_a_stations[str_key].start_node;
			nd_prev = undefined;
			m_a_stations[str_key].nodes = [];
			while ( isdefined( nd_next ) )
			{
				if ( isdefined( nd_prev ) )
				{
					nd_next.target2 = nd_prev.targetname;
				}
				
				if ( !isdefined( m_a_stations[str_key].nodes ) ) m_a_stations[str_key].nodes = []; else if ( !IsArray( m_a_stations[str_key].nodes ) ) m_a_stations[str_key].nodes = array( m_a_stations[str_key].nodes ); m_a_stations[str_key].nodes[m_a_stations[str_key].nodes.size]=nd_next;;
				
				nd_prev = nd_next;
				
				if ( !isdefined( nd_next.target ) )
				{
					break;
				}
				else
				{
					nd_next = GetVehicleNode( nd_next.target, "targetname" );
				}
			}
			
			// Junction node is the last in the list.
			num_nodes = m_a_stations[str_key].nodes.size;
			m_a_stations[str_key].junction_node = m_a_stations[str_key].nodes[num_nodes-1];
			
			// All paths start pointing toward junction.
			m_a_stations[str_key].path_toward_junction = true;
		}
		
		/#
		thread debug_draw_paths();
		#/
	
		assert( isdefined(e_train) );
		
		m_e_train = e_train;
		
		a_e_children = GetEntArray( m_e_train.target, "targetname" );
		foreach( e_ent in a_e_children )
		{
			if ( isdefined( e_ent.script_string ) )
			{
				if ( e_ent.script_string == "train_volume" )
				{
					assert( !isdefined( m_e_volume ) );  // Train should have only one volume.
					e_ent EnableLinkTo();
					m_e_volume = e_ent;
				}
				else if ( e_ent.script_string == "rear_door" || e_ent.script_string == "front_door" )
				{
					e_ent.script_origin = Spawn( "script_origin", e_ent.origin );
					e_ent.script_origin.angles = m_e_train.angles;
					e_ent.script_origin LinkTo( m_e_train );
					
					if ( !isdefined( m_a_doors ) ) m_a_doors = []; else if ( !IsArray( m_a_doors ) ) m_a_doors = array( m_a_doors ); m_a_doors[m_a_doors.size]=e_ent;;
				}
				
				if ( isdefined( e_ent.script_parameters ) )
				{
					e_ent.train_params = [];
					
					a_params = StrTok( e_ent.script_parameters, " " );
					foreach( param in a_params )
					{
						e_ent.train_params[param] = true;
					}
				}
				
				e_ent LinkTo( m_e_train );
			}
			else
			{
				/#
					IPrintLnBold( "Entity at " + zm_zod_util::vec_to_string( e_ent.origin ) + " is parented to train, but has no script_string identity." );
				#/
			}
		}
		
		/#
		if ( !isdefined( m_e_volume ) )
		{
			AssertMsg( "Train at " + zm_zod_util::vec_to_string(e_train.origin) + " has no volume." );
		}
		#/
		
		thread main();
		
		a_callboxes = GetEntArray( "train_call_lever", "targetname" );
		foreach( e_callbox in a_callboxes )
		{
			station_closest = array::get_closest( e_callbox.origin, m_a_stations );
			assert( isdefined( station_closest ) );
			e_callbox.script_string = station_closest.station_id;
			station_closest.callbox = e_callbox;
			thread run_callbox( e_callbox.script_string );
		}
		
		a_gates = GetEntArray( "train_gate", "targetname" );
		foreach( gate in a_gates )
		{
			station = m_a_stations[gate.script_string];
			if(!isdefined(station.gates))station.gates=[];
			if ( !isdefined( station.gates ) ) station.gates = []; else if ( !IsArray( station.gates ) ) station.gates = array( station.gates ); station.gates[station.gates.size]=gate;;
			jump_nodes = GetNodeArray( station.path_node.target, "targetname" );
			self thread run_gate( gate, jump_nodes );
		}
	}
	
	function main()
	{
		a_path_names = GetArrayKeys( m_a_stations );
		a_path_names = array::randomize( a_path_names );
		m_str_station = a_path_names[0];
		m_e_train AttachPath( m_a_stations[m_str_station].start_node );
		m_e_train.backwards = false;
		
		self thread watch_players_on_train();
		
		// Let the train attach to the path before spawning the trigger.
		wait 1.0;

		// Set up the unitrigger
		v_front = m_e_train GetTagOrigin( "tag_button_front" );
		m_s_trigger = zm_zod_util::spawn_trigger_radius( v_front, 60.0, true );
		
		self thread update_power_level();
		
		m_e_train playloopsound( "evt_train_idle_loop", 4 );
		
		open_doors();
		
		while( 1 )
		{
			update_use_trigger();
			while ( true )
			{
				m_s_trigger waittill( "trigger", e_who );
				
				// It can run for free even if it doesn't have power.
				if ( m_b_free )
				{
					m_b_free = false;
					break;
				}
				else if ( self flag::get( "fully_powered" ) )
				{
					if ( e_who.score < 500 )
					{
						e_who zm_audio::create_and_play_dialog( "general", "transport_deny" );
					}
					else
					{
						e_who zm_score::minus_to_player_score( 500 );
						break;
					}
				}
			}
			
			self flag::set( "moving" );
			zm_unitrigger::unregister_unitrigger( m_s_trigger );
			m_s_trigger = undefined;
			
			close_doors();
			
			m_e_train playsound( "evt_train_start" );
			m_e_train playloopsound( "evt_train_loop", 4 );
			
			move();
			
			m_e_train playloopsound( "evt_train_idle_loop", 4 );
			
			self flag::clear( "moving" );
		
			a_riders = get_players_on_train( false );
			if ( a_riders.size > 0 )
			{
				//TODO Use flags for zone activation, not a single zone.
				//	zones break if there are multiple connected zones.
				v_station = m_a_stations[m_str_station].origin;
				str_zone = zm_zonemgr::get_zone_from_position( v_station, true );
				if ( isdefined( str_zone ) )
				{
					zm_zonemgr::enable_zone( str_zone );
				}
			}
			
			open_doors();
			
			// Choose the position for the unitrigger.
			v_trig = (0,0,0);
			if ( !m_b_facing_forward )
			{
				v_trig = m_e_train GetTagOrigin( "tag_button_back" );
			}
			else
			{
				v_trig = m_e_train GetTagOrigin( "tag_button_front" );
			}
			
			// Set up the unitrigger
			m_s_trigger = zm_zod_util::spawn_trigger_radius( v_trig, 60.0, true );
			
			if ( !m_b_free )
			{
				self flag::set( "cooldown" );
				update_use_trigger();
				wait 30.0;
				self flag::clear( "cooldown" );
			}
		}
	}
	
	function run_callbox_hintstring( str_callbox, t_use )
	{
		while ( true )
		{	
			if ( !self flag::get( "fully_powered" ) )
			{
				t_use zm_zod_util::set_unitrigger_hint_string( &"ZM_ZOD_TRAIN_NOPOWER" );
				self flag::wait_till( "fully_powered" );
			}
			
			if ( m_str_station == str_callbox )
			{
				t_use zm_zod_util::set_unitrigger_hint_string( &"" );
			}
			else
			{				
				t_use zm_zod_util::set_unitrigger_hint_string( &"ZM_ZOD_TRAIN_CALL", 500 );
			}
			
			self flag::wait_till( "moving" );
			
			t_use zm_zod_util::set_unitrigger_hint_string( &"ZM_ZOD_TRAIN_MOVING" );			
			
			self flag::wait_till_clear( "moving" );
			
			if ( m_str_station == str_callbox )
			{
				t_use zm_zod_util::set_unitrigger_hint_string( &"" );
			}
			else
			{
				t_use zm_zod_util::set_unitrigger_hint_string( &"ZM_ZOD_TRAIN_COOLDOWN" );
			}
			
			self flag::wait_till_clear( "cooldown" );
		}
	}
	
	function run_callbox( str_callbox )
	{
		assert( isdefined( m_str_station ) );
		e_lever = m_a_stations[ str_callbox ].callbox;
		t_use = zm_zod_util::spawn_trigger_radius( e_lever.origin, 60.0, true );
		thread run_callbox_hintstring( str_callbox, t_use );
		
		while ( true )
		{
			t_use waittill( "trigger", e_who );
			
			if ( e_who.score < 500 )
			{
				e_who zm_audio::create_and_play_dialog( "general", "transport_deny" );
				continue;
			}
			
			if ( m_str_station != str_callbox && isdefined( m_s_trigger ) )
			{
				// Using the callbox always costs.
				m_b_free = false;
				
				direct_all_switches( str_callbox );
				m_s_trigger notify( "trigger", e_who );
				
				// Using the train immediately after the callbox is free.
				util::wait_network_frame();
				m_b_free = true;
				
				e_lever RotatePitch( 180, 0.5 );
				self flag::wait_till( "moving" );
				self flag::wait_till_clear( "moving" );
				e_lever RotatePitch( -180, 0.5 );
			}
		}
	}
	
	function run_gate( e_gate, a_jump_nodes )
	{
		const gate_size = 96.0;
		nd_start = m_a_stations[ e_gate.script_string ].start_node;
		v_open = e_gate.origin;
		v_closed = v_open + (AnglesToForward( nd_start.angles ) * gate_size);
		
		if ( m_a_stations[ e_gate.script_string ].door_side == "right" )
		{
			v_closed = v_open - (AnglesToForward( nd_start.angles ) * gate_size);
		}
		
		b_open = true;
		while ( true )
		{
			if ( b_open )
			{
				e_gate MoveTo( v_closed, 1.0 );
				b_open = false;
				
				foreach( nd in a_jump_nodes )
				{
					UnlinkTraversal( nd );
				}
			}
			
			self flag::wait_till_clear( "moving" );
			
			if ( m_str_station == e_gate.script_string )
			{
				e_gate MoveTo( v_open, 1.0 );
				b_open = true;
				e_gate waittill( "movedone" );
				
				foreach( nd in a_jump_nodes )
				{
					b_fwd_node = ( nd.script_string === "forward" );
					if ( (m_b_facing_forward && b_fwd_node) || (!m_b_facing_forward && !b_fwd_node) )
					{
						LinkTraversal( nd );
					}
				}
			}
			
			self flag::wait_till( "moving" );
		}
	}
	
	function get_door_open_pos( e_door )
	{			
		if ( e_door.script_string == "front_door" )
		{
			return e_door.script_origin.origin - AnglesToForward( e_door.script_origin.angles ) * 100.0;
		}
		else
		{
			return e_door.script_origin.origin + AnglesToForward( e_door.script_origin.angles ) * 100.0;
		}
	}
	
	function get_door_closed_pos( e_door )
	{
		return e_door.script_origin.origin;
	}
	
	function get_open_side()
	{
		str_station = get_current_destination();
		str_side = m_a_stations[ str_station ].door_side;
		
		if ( m_e_train.backwards )
		{
			if ( str_side == "left" )
			{
				return "right";
			}
			else if ( str_side == "right" )
			{
				return "left";
			}
		}
		
		return str_side;
	}
	
	function open_doors( str_side )
	{
		if ( !isdefined( str_side ) )
		{
			str_side = get_open_side();
		}
		
		a_doors_moved = [];
		foreach( e_door in m_a_doors )
		{
			if ( !isdefined( str_side ) || ( isdefined( e_door.train_params[ str_side ] ) && e_door.train_params[ str_side ] ) )
			{
				v_pos = get_door_open_pos( e_door );
				e_door Unlink();
				e_door MoveTo( v_pos, 0.3 );
				if ( !isdefined( a_doors_moved ) ) a_doors_moved = []; else if ( !IsArray( a_doors_moved ) ) a_doors_moved = array( a_doors_moved ); a_doors_moved[a_doors_moved.size]=e_door;;
			}
		}
		
		if ( a_doors_moved.size > 0 )
		{
			a_doors_moved[0] waittill( "movedone" );
		}
		
		util::wait_network_frame();
		foreach ( e_door in a_doors_moved )
		{
			v_pos = get_door_open_pos( e_door );
			e_door.origin = v_pos;
			e_door.angles = e_door.script_origin.angles;
			e_door LinkTo( m_e_train );
		}
		
		// They're no longer locked in.
		// Count backwards so as not to try and access removed entries.
		//
		for ( i = m_a_zombies_locked_in.size-1; i >= 0; i-- )
		{
			ai = m_a_zombies_locked_in[i];
			if ( isdefined( ai ) )
			{
				remove_zombie_locked_in( ai );
			}
		}
		
		m_a_zombies_locked_in = [];
	}
	
	function close_doors()
	{
		foreach( e_door in m_a_doors )
		{
			v_pos = get_door_closed_pos( e_door );
			e_door Unlink();
			e_door MoveTo( v_pos, 0.3 );
		}
		
		m_a_doors[0] waittill( "movedone" );
	
		util::wait_network_frame();
		foreach ( e_door in m_a_doors )
		{
			v_pos = get_door_closed_pos( e_door );
			e_door.origin = v_pos;
			e_door.angles = e_door.script_origin.angles;
			e_door LinkTo( m_e_train );
		}
		
		// Now that the doors are closed, start tracking which zombies are on the train.
		thread recalc_zombies_locked_in_train();
	}
	
	function recalc_zombies_locked_in_train()
	{
		zombies = GetAITeamArray( level.zombie_team );
		n_counter = 0;
		foreach( zombie in zombies )
		{
			if ( !isdefined( zombie ) || !IsAlive( zombie ) )
			{
				continue;
			}
			
			if ( is_touching_train_volume( zombie ) )
			{
				add_zombie_locked_in( zombie );
			}
			
			n_counter++;
			if ( n_counter % 3 == 0 )
			{
				util::wait_network_frame();
			}
		}
	}
	
	function waittill_any_power_switch( a_power_zones )
	{
		foreach( n_zone in a_power_zones )
		{
			level endon( "power_on" + n_zone );
		}
		
		level waittill( "never_notify" );
	}
	
	function update_use_trigger()
	{
		if ( !isdefined( m_s_trigger ) )
		{
			return;
		}
		
		if ( self flag::get( "fully_powered" ) )
		{
			if ( m_b_free )
			{
				m_s_trigger zm_zod_util::set_unitrigger_hint_string( &"ZM_ZOD_TRAIN_USE_FREE" );
			}
			else if ( is_cooling_down() )
			{
				m_s_trigger zm_zod_util::set_unitrigger_hint_string( &"ZM_ZOD_TRAIN_COOLDOWN" );
			}
			else
			{
				m_s_trigger zm_zod_util::set_unitrigger_hint_string( &"ZM_ZOD_TRAIN_USE", 500 );
			}	
		}
		else
		{
			if ( m_n_power > 0 )
			{
				m_s_trigger zm_zod_util::set_unitrigger_hint_string( &"ZM_ZOD_TRAIN_POWER_PCT", m_n_power );
			}
			else
			{
				m_s_trigger zm_zod_util::set_unitrigger_hint_string( &"ZM_ZOD_TRAIN_NOPOWER" );
			}
		}
	}
	
	function update_power_level()
	{
		a_power_zones = [];
		foreach( station in m_a_stations )
		{
			nd_start = station.start_node;
			if ( isdefined( nd_start.script_int ) )
			{
				if ( !isdefined( a_power_zones ) ) a_power_zones = []; else if ( !IsArray( a_power_zones ) ) a_power_zones = array( a_power_zones ); a_power_zones[a_power_zones.size]=nd_start.script_int;;
			}
		}
		
		/* TODO: re-enable this later, after we've platested.
		// Update the power hints as more power comes online.
		//
		n_powered_on = 0;
		while ( true )
		{
			n_powered_on = 0;
			foreach( n_zone in a_power_zones )
			{
				if ( level flag::get( "power_on" + n_zone ) )
				{
					n_powered_on++;
				}
			}
			
			if ( n_powered_on < a_power_zones.size )
			{
				n_pct = Int(100 * (Float( n_powered_on ) / Float( a_power_zones.size )));
				
				m_n_power = n_pct;
				
				update_use_trigger();
				
				waittill_any_power_switch( a_power_zones );
			}
			else
			{
				break;
			}
		}
		*/
		
		m_n_power = 100;
		self flag::set( "fully_powered" );
		update_use_trigger();
	}
	
	function send_train()
	{
		if ( isdefined( m_s_trigger ) )
		{
			m_b_free = true;
			m_s_trigger notify( "trigger" );
		}
	}
	
	function run_switch( str_switch )
	{
		e_switch = m_a_stations[str_switch].path_switch;
		e_active_switch = undefined;
		
		if ( RandomInt( 100 ) < 50 )
		{
			m_a_stations[str_switch].left_path_active = true;
		}
		else
		{
			m_a_stations[str_switch].left_path_active = false;
		}
		
		m_a_stations[str_switch].path_destination_light_anchor.origin = m_a_stations[str_switch].path_switch_right.origin;
		m_a_stations[str_switch].path_destination_light LinkTo( m_a_stations[str_switch].path_destination_light_anchor );
		zm_net::network_safe_play_fx_on_tag( "train_destination_light", 3,"light/fx_light_sat_relay_yellow", m_a_stations[str_switch].path_destination_light, "tag_origin" );
		
		
		while ( true )
		{
			if ( self flag::get( "switches_enabled" ) )
			{
				if( isDefined( e_active_switch ) )
				{
					e_old_active_switch = e_active_switch;
				}
				
				if ( m_a_stations[str_switch].left_path_active )
				{
					e_active_switch = m_a_stations[str_switch].path_switch_left;
				}
				else
				{
					e_active_switch = m_a_stations[str_switch].path_switch_right;
				}
				

				m_a_stations[str_switch].path_switch_right SetCanDamage( true );
				m_a_stations[str_switch].path_switch_left SetCanDamage( true );
			}
			
			
			m_a_stations[str_switch].path_destination_light_anchor.origin = e_active_switch.origin;
			
			e_active_switch util::waittill_any_ents( m_a_stations[str_switch].path_switch_left, "damage", e_active_switch, "force_switch", m_a_stations[str_switch].path_switch_right, "damage" );
			
			str_prev_dest = get_current_destination();
			if ( self flag::get( "switches_enabled" ) )
			{
				m_a_stations[str_switch].left_path_active = !m_a_stations[str_switch].left_path_active;
			}
			
			if ( is_moving() )
			{
				str_new_dest = get_current_destination();

				if ( str_new_dest != str_prev_dest )
				{
					str_divert = m_a_stations[ str_new_dest ].audio_divert;
					m_e_train playsound( str_divert );
				}
			}
			
			wait 0.5; //cooldown on switching in case people are shooting with auto weapons or multiple people shoot at the same time
		}
	}
	
	function watch_players_on_train()
	{
		/#
		foreach( e_player in level.players )
		{
			assert(isdefined(e_player.on_train));
		}
		#/
		
		while ( true )
		{
			// TODO: does this need to be net choked?
			foreach( e_player in level.players )
			{
				e_player.on_train = is_touching_train( e_player );
			}
			
			wait 0.5;
		}
	}
	
	function is_touching_train( e_ent )
	{
		return e_ent IsTouching( m_e_volume );
	}
	
	function watch_zombie_fall_off( ai )
	{
		ai endon( "death" );
		ai endon( "released_from_train" );
		
		zm_net::network_safe_init( "train_fall_check", 1 );
		while ( self zm_net::network_choke_action( "train_fall_check", &is_touching_train, ai ) )
		{
			wait 2.0;
		}
		remove_zombie_locked_in( ai );
	}
	
	function is_touching_train_volume( ent )
	{
		return ent IsTouching( m_e_volume );
	}
	
	function get_players_on_train( b_valid_targets_only = false )
	{
		a_players = [];
		foreach( e_player in level.players )
		{
			// Cull out ignored and downed players.
			//
			if ( b_valid_targets_only && (e_player.ignoreme || !zm_utility::is_player_valid( e_player )) )
			{
				continue;
			}
			
			if ( e_player.on_train )
			{
				if ( !isdefined( a_players ) ) a_players = []; else if ( !IsArray( a_players ) ) a_players = array( a_players ); a_players[a_players.size]=e_player;;
			}
		}
		
		return a_players;
	}
	
	function add_zombie_locked_in( ai_zombie )
	{
		ai_zombie.locked_in_train = true;
		array::add( m_a_zombies_locked_in, ai_zombie, false );
		thread watch_zombie_fall_off( ai_zombie );
	}
	
	function remove_zombie_locked_in( ai_zombie )
	{
		ai_zombie.locked_in_train = false;
		ArrayRemoveValue( m_a_zombies_locked_in, ai_zombie );
		ai_zombie notify( "released_from_train" );
	}
	
	// Removes deleted/dead zombies from the list.
	//
	function locked_in_list_remove_undefined()
	{
		m_a_zombies_locked_in = array::remove_undefined( m_a_zombies_locked_in );
	}
	
	function get_zombies_locked_in()
	{
		return m_a_zombies_locked_in;
	}
	
	function get_time_since_last_jumper()
	{
		return Float(GetTime() - m_n_last_jumper_time) / 1000.0;
	}
	
	function mark_jumper_time()
	{
		m_n_last_jumper_time = GetTime();
	}
	
	function jump_into_train( ai, str_tag )
	{
		self endon( "death" );
		s_tag = m_a_jumptags[ str_tag ];
		s_tag.occupied = true;
		v_tag_pos = m_e_train GetTagOrigin( str_tag );
		v_tag_angles = m_e_train GetTagAngles( str_tag );

		ai Teleport( v_tag_pos, v_tag_angles );
		
		util::wait_network_frame();
		
		ai LinkTo( m_e_train, str_tag );
		ai AnimScripted( "entered_train", v_tag_pos, v_tag_angles, s_tag.str_anim );
		ai zombie_shared::DoNoteTracks( "entered_train" );
		ai Unlink();
		
		s_tag.occupied = false;
		
		if ( is_moving() )
		{
			add_zombie_locked_in( ai );
		}
		
	}
	
	//////////////////////////////////////////////////////
	/// ACCESSORS
	//////////////////////////////////////////////////////
	
	// Junction position is average of the junction nodes.
	function get_junction_origin()
	{
		v_origin = (0,0,0);
		foreach( s_station in m_a_stations )
		{
			v_origin = v_origin + s_station.junction_node.origin;
		}
		
		v_origin = v_origin / Float(m_a_stations.size);
		return v_origin;
	}
	
	function is_moving()
	{
		return self flag::get( "moving" );
	}
	
	function is_cooling_down()
	{
		return self flag::get( "cooldown" );
	}
	
	function private any_player_facing_tag( str_tag )
	{
		foreach( e_player in level.players )
		{
			v_pos = m_e_train GetTagOrigin( str_tag );
			v_fwd = AnglesToForward( e_player.angles );
			v_to_tag = VectorNormalize( v_pos - e_player.origin );
			if ( VectorDot( v_fwd, v_to_tag ) > 0 )
			{
				return true;
			}
		}
		
		return false;
	}
	
	function get_available_jumptag()
	{
		a_valid_tags = [];
		foreach ( tag in m_a_jumptags )
		{
			if ( tag.occupied )
			{
				continue;
			}
			
			if ( !isdefined( a_valid_tags ) ) a_valid_tags = []; else if ( !IsArray( a_valid_tags ) ) a_valid_tags = array( a_valid_tags ); a_valid_tags[a_valid_tags.size]=tag;;
		}
		
		a_valid_tags = array::randomize( a_valid_tags );
		a_forward_tags = [];
		
		// Try to pick entrances that they're looking at.
		a_players = get_players_on_train( false );
		
		// Larger chance of entering in front of you than behind you.
		//
		n_roll = RandomInt( 100 );
		if ( n_roll < 80 && a_players.size > 0 )
		{
			foreach( s_tag in a_valid_tags )
			{
				if ( any_player_facing_tag( s_tag.str_tag ) )
				{
					if ( !isdefined( a_forward_tags ) ) a_forward_tags = []; else if ( !IsArray( a_forward_tags ) ) a_forward_tags = array( a_forward_tags ); a_forward_tags[a_forward_tags.size]=s_tag;;
				}
			}
		}
		
		// If they're backed into one side, make it less likely to choose the window behind them.
		//
		if ( a_forward_tags.size > 2 )
		{
			a_valid_tags = a_forward_tags;
		}
		
		if ( a_valid_tags.size == 0 )
		{
			return undefined;
		}
		else
		{
			return array::random( a_valid_tags );
		}
	}
	
	function get_origin()
	{
		return m_e_train.origin;
	}
}

/////////////////////////////////////////////
//                                         //
//          ZOMBIE AI VS. TRAIN            //
//                                         //
/////////////////////////////////////////////

function in_range_2d( v1, v2, range, vert_allowance )
{
	if ( abs(v1[2] - v2[2]) > vert_allowance )
	{
		return false;
	}
	
	return Distance2DSquared( v1, v2 ) < (range * range);
}

function enemy_location_override( zombie, enemy )
{
	if ( enemy.on_train )
	{
		b_moving = [[level.o_zod_train]]->is_moving();
		if ( b_moving && !self.locked_in_train )
		{
			return [[level.o_zod_train]]->get_destination_pos();
		}
	}
	
	return undefined;
}

function get_players_on_train( b_valid_targets_only = false )
{
	return [[level.o_zod_train]]->get_players_on_train( true );
}

function is_moving()
{
	return [[level.o_zod_train]]->is_moving();
}

function zombie_jump_onto_moving_train( ai )
{
	[[level.o_zod_train]]->mark_jumper_time();
	spot = [[level.o_zod_train]]->get_available_jumptag();
	if ( isdefined( spot ) )
	{
		ai.str_train_tag = spot.str_tag;
		[[level.o_zod_train]]->jump_into_train( ai, spot.str_tag );
	}
}

function remove_dead_zombie()
{
	if ( isdefined( self ) )
	{
		b_on_train = false;
		if ( is_moving() )
		{
			if ( self.locked_in_train )
			{
				b_on_train = true;
			}
		}
		else if ( [[level.o_zod_train]]->is_touching_train_volume( self ) )
		{
			b_on_train = true;
		}
		
		if ( b_on_train )
		{
			self clientfield::set( "zombie_gut_explosion", 1 );
			self Ghost();
		}
	}
	
	if ( isdefined( self ) && self.locked_in_train )
	{
		[[level.o_zod_train]]->remove_zombie_locked_in( self );
	}
	else
	{
		[[level.o_zod_train]]->locked_in_list_remove_undefined();
	}
}

function get_num_zombies_locked_in()
{
	a_zombies = [[level.o_zod_train]]->get_zombies_locked_in();
	return a_zombies.size;
}

function is_full()
{
	return get_num_zombies_locked_in() >= 6;
}

function is_ready_for_jumper()
{
	return [[level.o_zod_train]]->get_time_since_last_jumper() > 10.0;
}

/#

function debug_go_to_train()
{
	train = GetEnt( "zod_train", "targetname" );
	if( isdefined( train ) )
	{
		train_origin = train getorigin();
		player = level.players[0];
		if( isdefined( player ) && isdefined( train_origin ) )
		{
			train_origin = ( train_origin[0], train_origin[1], train_origin[2] - 100 );
		   	player setorigin( train_origin );
		}
	}
}	

function train_devgui()
{
	SetDvar( "train_devgui_command", "" );
	
	AddDebugCommand( "devgui_cmd \"ZM/Zod/Train/Canals\" \"train_devgui_command c\"\n" );
	AddDebugCommand( "devgui_cmd \"ZM/Zod/Train/Slums\" \"train_devgui_command a\"\n" );
	AddDebugCommand( "devgui_cmd \"ZM/Zod/Train/Theater District\" \"train_devgui_command b\"\n" );
	AddDebugCommand( "devgui_cmd \"ZM/Zod/Train/Open Doors\" \"train_devgui_command open_doors\"\n" );
	AddDebugCommand( "devgui_cmd \"ZM/Zod/Train/Close Doors\" \"train_devgui_command close_doors\"\n" );
	AddDebugCommand( "devgui_cmd \"ZM/Zod/Train/Debug\" \"train_debug 1\"\n" );
	AddDebugCommand( "devgui_cmd \"ZM/Zod/Train/Go To Train\" \"train_devgui_command go_to_train\"\n" );
	
	while ( true )
	{
		cmd = GetDvarString( "train_devgui_command" );
		if ( cmd != "")
		{
			switch ( cmd )
			{
				case "a":
				case "b":
				case "c":
					[[level.o_zod_train]]->direct_all_switches( cmd );
					break;
				case "open_doors":
					[[level.o_zod_train]]->open_doors();
					break;
				case "close_doors":
					[[level.o_zod_train]]->close_doors();
					break;
				case "go_to_train":
					debug_go_to_train();
					break;
				default:
					break;
			}
			
			SetDvar( "train_devgui_command", "" );
		}
		util::wait_network_frame();
	}
}
#/
