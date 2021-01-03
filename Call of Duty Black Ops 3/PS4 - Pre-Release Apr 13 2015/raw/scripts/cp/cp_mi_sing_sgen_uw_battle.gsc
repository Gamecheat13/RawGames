#using scripts\codescripts\struct;

#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\colors_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;

#using scripts\cp\_dialog;
#using scripts\cp\_objectives;
#using scripts\cp\_skipto;
#using scripts\cp\_spawn_manager;
#using scripts\cp\_util;

#using scripts\cp\cp_mi_sing_sgen;
#using scripts\cp\cp_mi_sing_sgen_util;

                                                                                                            	   	
    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

function skipto_underwater_init( str_objective, b_starting )
{
	level clientfield::set( "w_underwater_state", 1 );

	SetDvar("player_swimTime", 5000);
	SetDvar("player_swimcantraverse", 1);

	SetJumpHeight( 256 );

	level flag::wait_till( "all_players_spawned" );
	
	level util::clientnotify("tuwc"); //trigger under water context

	if ( b_starting )
	{
		sgen::init_hendricks( str_objective );

		objectives::set( "cp_level_sgen_escape_sgen" );
	}
	else
	{
		skipto::teleport( "underwater_battle" ); // Always teleport to skipto start positions
	}

	array::thread_all( GetEntArray( "exhaust_fan", "targetname" ), &exhaust_fan );
	exploder::exploder( "underwater_battle_fan_vortex" );

	spawner::add_global_spawn_function( "axis", &sgen_util::robot_underwater_callback );
	
	scene::add_scene_func( "cin_sgen_25_02_siloswim_vign_windowbang_54i01_drowning", &drowning_54i_1, "play" );
	scene::add_scene_func( "cin_sgen_25_02_siloswim_vign_windowbang_54i02_drowning", &drowning_54i_2, "play" );
	scene::add_scene_func( "cin_sgen_25_02_siloswim_vign_windowbang_54i03_drowning", &drowning_54i_3, "play" );
	
	level thread scene::init( "hendricks_door_explosion" );
	
	main();
	
	skipto::objective_completed( "underwater_battle" );
}

function skipto_underwater_done( str_objective, b_starting, b_direct, player )
{
	//	SetJumpHeight( 39 );
	
	scene::remove_scene_func( "cin_sgen_25_02_siloswim_vign_windowbang_54i01_drowning", &drowning_54i_1, "play" );
	scene::remove_scene_func( "cin_sgen_25_02_siloswim_vign_windowbang_54i02_drowning", &drowning_54i_2, "play" );
	scene::remove_scene_func( "cin_sgen_25_02_siloswim_vign_windowbang_54i03_drowning", &drowning_54i_3, "play" );
}

function main()
{
	t_undertow = GetEnt( "fan_undertow", "targetname" );
	t_undertow thread fan_undertow();
	level util::clientnotify ( "underwater_fan" );
	level util::clientnotify("tuwc"); //trigger under water context
	level thread drowning_54i();

	foreach( player in level.players )
	{
		player SetPlayerGravity( 150 );
	}
	level thread handle_player_swimming();

	level thread vo();
	
	spawn_manager::enable( "uw_battle_spawnmanager" );
	
	scene::add_scene_func( "cin_sgen_23_01_underwater_battle_vign_swim_hendricks_groundidl", &set_up_hendricks_swim, "play" );
	level scene::play( "cin_sgen_23_01_underwater_battle_vign_swim_hendricks_groundidl" );
	
	level notify( "hendricks_grounded" );
	
	level flag::wait_till( "hendricks_uwb_to_catwalk" );

	// Move up to the catwalk
	level thread scene::play( "cin_sgen_23_01_underwater_battle_vign_swim_hendricks_move2catwalk" );
	level.ai_hendricks waittill( "idle_started" );
	level flag::wait_till( "hendricks_uwb_to_window" );

	// Move up to the window
	level scene::play( "cin_sgen_23_01_underwater_battle_vign_swim_hendricks_traverse_room", level.ai_hendricks);
}

function set_up_hendricks_swim( a_ents )
{
	level.ai_hendricks ai::set_ignoreme( true );
}

function vo()
{
	level dialog::remote( "hend_what_now_kane_0", RandomFloatRange( 1.2, 1.5 ) );	// What now, Kane??
	
	level waittill( "hendricks_grounded" );
	
	level dialog::remote( "kane_above_you_marking_y_0", RandomFloatRange( .1, .25 ) ); // Above you. Marking your HUD, Hendricks.
	
	t_trigger = GetEnt( "uw_rail_sequence_start", "targetname" );
	s_gather = struct::get( t_trigger.target, "targetname" );
	
	objectives::set( "cp_level_sgen_breadcrumb" , s_gather );
	
	level waittill( "hendricks_in_position" ); // Sent via notetrack - ch_sgen_23_01_underwater_battle_vign_swim_hendricks_roomtraverse
	
	level dialog::remote( "kane_blow_that_door_wate_0", RandomFloatRange( .1, .25 ) ); // Blow that door. Water pressure will shoot you straight up to the silo!
	
	level flag::wait_till( "hendricks_uwb_to_window" );
	
	level dialog::remote( "hend_on_me_once_i_blow_t_0", RandomFloatRange( .1, .25 ) );	// On me! Once I blow the door the pressure’s gonna yank us outta here!!
}

function handle_player_swimming()
{
	t_walk = getent( "underwater_walk_trigger", "targetname" );

	while ( IsDefined( t_walk ) )
	{
		foreach( player in level.players )
		{
			if ( IsDefined( player ) )
			{
				if( player istouching( t_walk ) )
				{
					if( !isdefined( player.isWaterWalking ) )
					{
						player.isWaterWalking = true;
						player WalkUnderwater(true);
						setdvar( "player_underwaterWalkSpeedScale", 1 );
						player clientfield::set_to_player( "sndSgenUW", 1 );
					}
				}
				else
				{
					if( isdefined( player.isWaterWalking ) )
					{
						player.isWaterWalking = undefined;
						player WalkUnderwater(false);
						player clientfield::set_to_player( "sndSgenUW", 0 );
					}
				}
				wait(0.05);
			}
		}
	}
}


//
//	Fans are directing water flow downwards
// Self is trigger
function fan_undertow()
{
	self endon( "death" );
	
	n_ceiling = self.origin[2];	//	Use the origin of the trigger to determine the ceiling Z-height
	n_max_distance = 300;
	n_power = 30;

	while ( true )
	{
		self waittill( "trigger", player );

		n_distance = n_ceiling - player.origin[2];
		if ( n_distance < n_max_distance )
		{
			n_push_strength = MapFloat( 0, n_max_distance, n_power, 0.0, n_distance );
			v_velocity = player GetVelocity() - (0,0,n_push_strength);

			player SetVelocity( v_velocity );
		}
	}
}

function exhaust_fan()
{
	// TODO: TEMP -- should make this an FX

	while ( IsDefined( self ) )
	{
		self RotateYaw( -180, 0.3 );

		wait ( 0.2 );
	}
}

function drowning_54i()
{
	a_ai = GetAITeamArray( "axis", "team3" );

	foreach( ai in a_ai )
	{
		if ( !(isdefined(ai.archetype) && ( ai.archetype == "robot" )) )
		{
			ai util::delay( RandomFloatRange( 0.05, 0.75 ), "death", &Kill ); // Floating Human 54i seamless from Flood Combat
		}
	}

	s_lookat = struct::get( "underwater_battle_drowning_54i_lookat" );
	s_a_scriptbundles = struct::get_array( "underwater_battle_drowning_54i" );

	array::thread_all( s_a_scriptbundles, &scene::play );

//	can_see = false;
//
//	wait ( 4 ); // Random to let players swim out
//
//	while ( !can_see )
//	{
//		foreach ( player in level.players )
//		{
//			if ( player util::is_player_looking_at( s_lookat.origin, 0.8, false ) )
//			{
//				can_see = true;
//			}
//		}
//
//		wait ( 0.05 );
//	}
//
//	a_e_54i = GetEntArray( "drowning_54i", "targetname" );
//
//	foreach ( e_54i in a_e_54i )
//	{
//		s_scriptbundle = array::get_closest( e_54i.origin, s_a_scriptbundles );
//
//		if ( !IsDefined( s_scriptbundle.script_noteworthy ) )
//		{
//			s_scriptbundle thread scene::play( e_54i );
//		}
//		else
//		{
//			s_scriptbundle thread scene::play( e_54i );
//		}
//	}
}

function drowning_54i_1( a_ents )
{
	wait ( RandomFloatRange( 1.0, 2.5 ) ); // How long they hold their breath
	
	self scene::play( "cin_sgen_25_02_siloswim_vign_windowbang_54i01_drowning2death", a_ents );
}

function drowning_54i_2( a_ents )
{
	wait ( RandomFloatRange( 1.0, 2.5 ) ); // How long they hold their breath

	self scene::play( "cin_sgen_25_02_siloswim_vign_windowbang_54i02_drowning2death", a_ents );
}

function drowning_54i_3( a_ents )
{
	wait ( RandomFloatRange( 1.0, 2.5 ) ); // How long they hold their breath

	self scene::play( "cin_sgen_25_02_siloswim_vign_windowbang_54i03_drowning2death", a_ents );
}
