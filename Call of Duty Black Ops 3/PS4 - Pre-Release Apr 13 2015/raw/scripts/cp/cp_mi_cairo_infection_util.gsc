#using scripts\codescripts\struct;

#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\hud_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\turret_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\lui_shared;

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

                                               	                                                          	              	                                                                                           

#using scripts\cp\_skipto;
#using scripts\cp\_spawn_manager;
#using scripts\cp\_util;
#using scripts\cp\_objectives;

#precache( "objective", "cp_standard_breadcrumb" );

#namespace infection_util;

function autoexec __init__sytem__() {     system::register("infection_util",&__init__,undefined,undefined);    }
	
function __init__()
{	
	sp_sarah = GetEnt( "sarah", "targetname" );
	
	if ( IsDefined( sp_sarah ) )
	{
		sp_sarah spawner::add_spawn_function( &spawn_func_toggle_light_flash );
	}
	
	level.lighting_state = 0;
	callback::on_spawned( &on_player_spawned );

	setup_anim_callbacks();

	callback::on_disconnect( &on_player_disconnect );
	callback::on_spawned( &snow_fx_play );
	callback::on_actor_killed( &ai_death_explosions );
	
	// clientfield setup
	init_client_field_callback_funcs();


	level thread setup_snow_triggers();
}

function init_client_field_callback_funcs()
{
	// clientfield setup
	clientfield::register( "toplayer", 		"snow_fx", 						1, 2, "int" );	
	clientfield::register( "actor", 		"sarah_objective_light",	 	1, 1, "int" );
	clientfield::register( "actor", 		"sarah_light_dim", 				1, 1, "int" );
	clientfield::register( "actor", 		"reverse_arrival_snow_fx", 		1, 1, "int" );
	clientfield::register( "actor", 		"reverse_arrival_dmg_fx", 		1, 1, "int" );
	clientfield::register( "actor", 		"exploding_ai_deaths", 			1, 1, "int" );
	clientfield::register( "actor", 		"reverse_arrival_explosion_fx", 1, 1, "int" );
	clientfield::register( "allplayers",	"player_spawn_fx", 				1, 1, "int" );
	clientfield::register( "toplayer", 		"stop_post_fx", 				1, 1, "counter" );
	clientfield::register( "actor",			"sarah_spawn_fx", 				1, 1, "int" );
		
	//postfx for dni interruption
	clientfield::register( "toplayer", "postfx_dni_interrupt", 1, 1, "counter" );
	clientfield::register( "toplayer", "postfx_futz", 1, 1, "counter" );		

	//HACK copied from _gadget_camo, trying this out on Sarah
	clientfield::register( "actor", "sarah_camo_shader", 1, 3, "int" );

}

function on_player_spawned()
{

}

function on_player_disconnect()  // self = player
{

}

function get_structs_with_objective_string( str_objective_string )
{
	 a_structs = struct::get_array( "cp_coop_spawn", "targetname" );
	 Assert( a_structs.size, "cp_coop_spawns are missing!" );
	 
	 a_found = [];
	 
	 for ( i = 0; i < a_structs.size; i++ )
	 {
	 	if ( ( a_structs[ i ].script_objective === str_objective_string ) )
	 	{
	 		if ( !isdefined( a_found ) ) a_found = []; else if ( !IsArray( a_found ) ) a_found = array( a_found ); a_found[a_found.size]=a_structs[ i ];;
	 	}
	 }
	 
	 Assert( a_found.size, "get_structs_with_objective_string found no cp_coop_spawn structs with script_objective = " + str_objective_string );
	 
	 return a_found;
}

function wait_for_player_spawn()
{
	level flag::wait_till( "all_players_connected" );
	
	do 
	{
		wait 0.05;
		
		n_players_playing = 0;
		
		foreach ( player in GetPlayers() )
		{
			if ( player.sessionstate == "playing" )
			{
				n_players_playing++;
			}
		}
	}
	while ( n_players_playing == 0 );
}

function gather_players_inside_volume( str_volume_name, str_key = "targetname" )
{
	Assert( IsDefined( str_volume_name ), "gather_players_inside_volume: str_volume_name is missing!" );
	
	e_volume = GetEnt( str_volume_name, str_key );
	Assert( IsDefined( e_volume ), "gather_players_inside_volume: entity with KVP '" + str_key + "' = '" + str_volume_name + "' not found!" );
	Assert( IsDefined( e_volume.target ), "gather_players_inside_volume: " + str_volume_name + " is missing a target! This determines the warp points." );
	
	a_gather_structs = struct::get_array( e_volume.target, "targetname" );
	Assert( ( a_gather_structs.size >= 4 ), "gather_players_inside_volume: " + str_volume_name + " found insufficient gather structs! Need 4+, found " + a_gather_structs.size );
	
	foreach ( i, player in level.players )
	{
		if ( !player IsTouching( e_volume ) )
		{			
			player SetOrigin( a_gather_structs[ i ].origin );
			player SetPlayerAngles( a_gather_structs[ i ].angles );
		}
	}
}

function spawn_func_toggle_light_flash()  // self = AI
{
	self endon( "death" );
	
	while ( true )
	{
		self waittill( "fx_flash_start" );  // sent from anim notetrack
		
		self light_flash_bright( true );
		
		self waittill( "fx_flash_stop" );  // sent from anim notetrack
		
		self light_flash_bright( false );
	}
}

function light_flash_bright( b_show = true )  // self = actor
{
	self clientfield::set( "sarah_objective_light", b_show );
}

function light_flash_dim( b_show = true )  // self = actor
{
	self clientfield::set( "sarah_light_dim", b_show );
}

// a custom spawn for Foy that piggyback to set_goal_on_spawn. This function will setup the AI to be more WWII style first before calling set_goal_on_spawn.
function set_goal_on_spawn_foy()
{
	// self ai
	self endon( "death" );
	
	// This spawn function bypasses any AI spawn by a time reverse script bundle, they should be handle by scene_callback_reverse_time_play_foy().
	if ( IsDefined( self.animname ) )
	{
		return;
	}
	
	self.overrideActorDamage = &callback_foy_ai_damage;
	
	self foy_custom_ai_spawn_behaivor();
}

function callback_foy_ai_damage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, modelIndex, psOffsetTime, boneName )
{
	if( ! IsPlayer(eAttacker) )
	{
		iDamage = Int( Abs( iDamage / 2 ) );
	}
	
	return( iDamage );
}

function foy_custom_ai_spawn_behaivor( str_target = undefined, str_script_noteworthy = undefined )
{
	// self = ai entity
	self endon( "death" );
	
	// Wait for the scene to stop playing
	while( 1 )
	{
		if( !IsDefined(self.current_scene) )
		{
			break;
		}
		wait( 0.05 );
	}
	
	if ( !IsDefined( str_target ) )
	{
		if ( IsDefined( self.target ) )
		{
			str_target = self.target;
		}
	}
	
	if ( !IsDefined( str_script_noteworthy ) )
	{
		if ( IsDefined( self.script_noteworthy ) )
		{
			str_script_noteworthy = self.script_noteworthy;
		}
	}
	
	if ( IsDefined( str_target ) )
	{
		e_target = GetNode( str_target, "targetname" );
		self SetGoal( e_target );
		self waittill( "goal" );
		self.goalradius = 64;
	}
}

function set_goal_on_spawn( n_goal_radius )
{
	self endon( "death" );
	
	if ( IsDefined( self.target ) )
	{
		e_target = GetEnt( self.target, "targetname" );
		
		if ( !IsDefined( e_target ) )
		{
			e_target = GetNode( self.target, "targetname" );
		}
		
		if ( IsDefined( e_target ) )
		{
			self SetGoal( e_target );
		}
		
		if ( IsDefined( n_goal_radius ) )
		{
			n_goal_radius_old = self.goalradius;
			
			self.goalradius = n_goal_radius;
			
			self waittill( "goal" );
			
			self.goalradius = n_goal_radius_old;
		}
	}
}

function create_trigger_radius( v_position, n_radius, n_height, n_spawn_flags = 0, str_trigger_type = "trigger_radius" )  // self = trigger
{
	Assert( IsDefined( v_position ), "v_position is required for create_trigger_radius_use!" );
	Assert( IsDefined( n_radius ), "n_radius is required for create_trigger_radius_use!" );
	Assert( IsDefined( n_height ), "n_height is required for create_trigger_radius_use!" );
	
	t_use = Spawn( str_trigger_type, v_position, n_spawn_flags, n_radius, n_height );
	
    t_use TriggerIgnoreTeam();
    t_use SetVisibleToAll();
    t_use SetTeamForTrigger( "none" );
    t_use UseTriggerRequireLookAt();	
    
    if ( str_trigger_type == "trigger_radius_use" )
    {
    	t_use SetCursorHint( "HINT_NOICON" );  // text will not show up without this call
    }
    
    return t_use;
}

// call on reference object (anything with a .origin field)
function slow_nearby_players_for_time( n_distance_to_slow, n_duration = 2, n_loop_time = 0.25, n_timeout = 2 )
{
	for ( n_time = 0; n_time < n_duration; n_time+= n_loop_time )
	{
		slow_nearby_players( n_distance_to_slow, n_timeout );
		
		wait n_loop_time;
	}
}

// call on reference object (anything with a .origin field)
function slow_nearby_players( n_distance_to_slow, n_timeout )
{
	foreach ( player in level.players )
	{
		player thread slow_player_within_range_for_time( self, n_distance_to_slow, n_timeout );
	}
}

function slow_player_within_range_for_time( e_reference, n_distance_to_slow, n_timeout = 1 )  // self = player
{	
	self endon( "death" );
	
	n_current_distance = Distance( self.origin, e_reference.origin );
	
	self.slowdown_amount = MapFloat( 0, n_distance_to_slow, 0.1, 1, n_current_distance );
		
	self SetMoveSpeedScale( self.slowdown_amount );
	
	if(!isdefined(self.slowdown_check_running))self.slowdown_check_running=false;
	
	self.slowdown_time_stop = ( GetTime() + ( ( n_timeout - 1 ) * 1000 ) );  // time in ms
	
	// only use one thread here to check time
	if ( !self.slowdown_check_running )
	{
		self.slowdown_check_running = true;
		
		while ( GetTime() < self.slowdown_time_stop )
		{	
			wait 0.1;
		}
		
		// restore speed over 1 second max
		while ( self.slowdown_amount < 1 )
		{
			self.slowdown_amount = math::clamp( self.slowdown_amount + 0.1, 0, 1 );
			
			self SetMoveSpeedScale( self.slowdown_amount );
			
			wait 0.1;
		}
		
		self SetMoveSpeedScale( 1 );  // fully restore speed
		
		self.slowdown_check_running = false;
	}
}

function set_global_snow_fx( n_id )
{
	Assert( IsDefined( n_id ), "set_global_snow_fx: FX ID is missing!" );
	
	level.snow_fx_id = n_id;
}

function get_global_snow_fx()
{
	if(!isdefined(level.snow_fx_id))level.snow_fx_id=0;
	
	return level.snow_fx_id;
}

function turn_on_snow_fx_for_all_players( n_id = 2 )
{
	set_global_snow_fx( n_id );
	
	foreach ( player in level.players )
	{
		player snow_fx_play( n_id );
	}	
}

function turn_off_snow_fx_for_all_players()
{
	set_global_snow_fx( 0 );
	
	foreach ( player in level.players )
	{
		player snow_fx_stop();
	}	
}

function snow_fx_play( n_id )
{
	Assert( IsPlayer( self ), "snow_fx_play() should only be called on players!" );
	
	if ( !IsDefined( n_id ) )
	{
		n_id = get_global_snow_fx();
	}
	
	self clientfield::set_to_player( "snow_fx", n_id );
}

function snow_fx_stop( b_pause = false )
{
	Assert( IsPlayer( self ), "snow_fx_stop() should only be called on players!" );
	
	self clientfield::set_to_player( "snow_fx", 0 );	
	
	// kills any looping checks against triggers
	if ( !b_pause )
	{
		self notify( "snow_fx_disabled" );  
		self.disable_snowfall_trigger_active = false;
	}
}

function link_traversals( str_value, str_key, b_enable )
{
	a_nodes = GetNodeArray( str_value, str_key );
	
	foreach ( node in a_nodes )
	{
		if ( node is_traversal_begin_node() )
		{
			if ( b_enable )
			{
				LinkTraversal( node );
			}
			else 
			{
				UnlinkTraversal( node );
			}
		}
	}
}

function is_traversal_begin_node()  // self = node
{
	return ( self.type === "Begin" );  // LinkTraversal must be called on type node_negotiation_begin
}

function trigger_disable_snowfall()  // self = trigger
{
	self endon( "death" );
	
	while ( true )
	{
		self waittill( "trigger", player );
		
		self thread disable_snowfall_while_inside_trigger( player );
	}
}

function disable_snowfall_while_inside_trigger( player )
{
	player endon( "death" );
	player endon( "snow_fx_disabled" );
	
	if(!isdefined(player.disable_snowfall_trigger_active))player.disable_snowfall_trigger_active=false;
	
	if ( !player.disable_snowfall_trigger_active )
	{
		player.disable_snowfall_trigger_active = true;
		
		// stop snow fx
		n_clientfield_state = player clientfield::get_to_player( "snow_fx" );
		player snow_fx_stop( true );
		
		while ( player IsTouching( self ) )
		{
			wait 0.25;
		}
		
		player.disable_snowfall_trigger_active = false;
		
		// restart snow fx
		player snow_fx_play( n_clientfield_state );
	}
}

function play_dialog( str_line )
{
	/# iprintlnbold( str_line ); #/
}

function teleport_coop_players_after_shared_cinematic( a_ents )
{
	if ( level.players.size > 1 )  // only use this if we're in co-op; solo players don't need a warp
	{
		//cover telporting with flash and quake
		level thread util::screen_fade_in( 1, "white" );		
		
		earthquake( 0.5, 0.5, level.players[0].origin, 500 );
		
		util::teleport_players_igc( level.skipto_point );		

		foreach ( player in level.players )
		{
			player playrumbleonentity( "damage_heavy" );
		}
	}
}

function setup_anim_callbacks()
{
	scene::add_scene_func( "cin_inf_00_00_sarah_vign_move_idle", &infection_util::callback_scene_objective_light_enable, "play" );
	//	scene::add_scene_func( "cin_inf_00_00_sarah_vign_move_idle", &infection_util::callback_scene_objective_light_disable, "stop" ); //Once we have trail fx put this back

	// this is where all reverse time animation callbacks should be set up, as they're generic and can apply to multiple areas
	scene::add_scene_func( "cin_inf_06_03_bastogne_aie_reversemg42", &callback_reverse_time_group_mg42_init, "init" );
	scene::add_scene_func( "cin_inf_06_03_bastogne_aie_reversemg42", &callback_reverse_time_group_mg42_play, "play" );
		
	scene::add_scene_func( "ch_inf_06_03_bastogne_aie_reverse_soldier01hipshot", &callback_reverse_fx_play, "play" );
	scene::add_scene_func( "cin_inf_06_03_bastogne_aie_reverse_soldier02headshot", &callback_reverse_fx_play, "play" );
	scene::add_scene_func( "cin_inf_06_03_bastogne_aie_reverse_soldier02headshot_sniper", &callback_reverse_fx_play, "play" );
	
	scene::add_scene_func( "cin_inf_06_03_bastogne_vign_reversebackroll", &callback_reverse_fx_play, "play" );	
	scene::add_scene_func( "cin_inf_06_03_bastogne_vign_reverseforwardroll", &callback_reverse_fx_play, "play" );

	scene::add_scene_func( "cin_inf_06_03_bastogne_aie_reverse_soldier01hipshot", &callback_reverse_fx_play, "play" );
}


//*****************************************************************************
// params on the bundle:-
// - target: if set then the targetname of a trigger
// - radius: if no target, then a spawn radius
// - script_delay: An optional delay before triggering
//*****************************************************************************

function setup_reverse_time_arrivals( str_group )
{
	// scene bundles are structs
	a_scene_bundles = struct::get_array( str_group, "targetname" );
	Assert( a_scene_bundles.size, "setup_reverse_time_arrivals found no scene bundles with targetname = '" + str_group + "'!" );
	
	level thread array::spread_all( a_scene_bundles, &_init_reverse_time_arrival );
}

function _init_reverse_time_arrival()  // self = struct (scene bundle)
{
	// only spawn in if there are enough players
	if ( !IsDefined( self.script_minplayers ) || ( self.script_minplayers <= level.players.size ) )
	{
		scene::add_scene_func( self.scriptbundlename, &scene_callback_reverse_time_init, "init" );
		scene::add_scene_func( self.scriptbundlename, &scene_callback_reverse_time_done, "done" );
		
		scene::init( self.scriptbundlename );
		
		if(!isdefined(self.radius))self.radius=800;
		if(!isdefined(self.height))self.height=512;
		if(!isdefined(self.script_int))self.script_int=0;  // used as a Z offset; required in the multi-story and terrain parts of map
		
		v_origin_offset = ( 0, 0, self.script_int );
		
		// spawners can manually use a trigger, or we can spawn one to use
		if ( IsDefined( self.target ) )
		{
			t_start = GetEnt( self.target, "targetname" );
		
			// Does the trigger exist?
			if ( !IsDefined( t_start ) )
			{
				//AssertMsg( "_init_reverse_time_arrival missing trigger target: " + self.target );

				// Can't find trigger so spawn a radius
				t_start = create_trigger_radius( self.origin + v_origin_offset, self.radius, self.height );
			}
		}
		else 
		{
			t_start = create_trigger_radius( self.origin + v_origin_offset, self.radius, self.height );
		}
		
		t_start.script_noteworthy = "reverse_anim_trigger";
		
		if(!isdefined(t_start.reverse_time_arrivals_using))t_start.reverse_time_arrivals_using=0;
		t_start.reverse_time_arrivals_using++;
		
		t_start waittill( "trigger" );
		t_start.reverse_time_arrivals_using--;
		if ( t_start.reverse_time_arrivals_using == 0 )
		{
			t_start Delete();
		}

		// Optional delay on animation start
		if ( IsDefined( self.script_delay ) )
		{
			wait self.script_delay;
		}
		
		scene::play( self.scriptbundlename );
	}
}


//*****************************************************************************
// Reverse time mortar explosion guys
//*****************************************************************************

function scene_callback_reverse_time_init( a_ents )
{			
	foreach ( ent in a_ents )
	{
		if ( IsActor( ent ) )
		{
			if( ( isdefined( level.reduce_german_accuracy ) && level.reduce_german_accuracy ) )
			{
				ent.script_accuracy = level.bastogne_reduced_accurcy;
			}
			
			ent reverse_time_set_on_ai( true );
			ent thread reverse_guy_goto_target_init( self );
		}
	}
}

function scene_callback_reverse_time_done( a_ents )
{	
	foreach ( ent in a_ents )
	{		
		if ( IsActor( ent ) )
		{
			ent reverse_time_set_on_ai( false );
		}
	}	
}


//*****************************************************************************
// FOY ONLY
//*****************************************************************************

function scene_callback_reverse_time_play_foy( a_ents )
{
	str_target = undefined;
	str_script_noteworthy = undefined;
	
	if ( IsDefined( self.target ) )
	{
		str_target = self.target;
	}
	
	if ( IsDefined( self.script_noteworthy ) )
	{
		str_script_noteworthy = self.script_noteworthy;
	}
	
	foreach ( ent in a_ents )
	{		
		if ( IsActor( ent ) )
		{
			ent reverse_time_set_on_ai( false );
			
			ent thread foy_custom_ai_spawn_behaivor( str_target, str_script_noteworthy );
		}
	}	
}

function reverse_time_set_on_ai( b_set )  // self = AI
{
	self ai::set_ignoreall( b_set );
	self ai::set_ignoreme( b_set );
	
	if ( b_set )
	{
		self DisableAimAssist();
		// TODO: make crosshairs white so players can't tell these guys are coming back to life (requires code)
	}
	else 
	{
		self EnableAimAssist();
		// TODO: turn crosshairs red again
	}
}

function get_closest_player_to_position( v_position )
{
	return ArraySort( level.players, v_position, true )[ 0 ];
}


//*****************************************************************************
// Called when a reverse anim is played
//*****************************************************************************

// self = script struct bundle
function callback_reverse_fx_play( a_ents )
{
	foreach( ent in a_ents )
	{
		self thread reverse_fx_play( ent );
	}	
}	


//*****************************************************************************
//*****************************************************************************
// Reverse arrivals
//*****************************************************************************
//*****************************************************************************

// self = anim bundle
function reverse_fx_play( ent )
{
	ent endon( "death" );
	
	if ( IsActor( ent ) )
	{
		ent thread reverse_guy_goto_target_init( self );

		// Any effects to play?
		if( IsSubStr( ent.current_scene, "hipshot" ) ) 
		{	
			// Snow impact in reverse.
			ent clientfield::set( "reverse_arrival_snow_fx", 1 );
			//waiting 1 second till raise up a bit for blood shot, needs notetrack to time right
			wait 1; 
			ent clientfield::set( "reverse_arrival_dmg_fx", 0 );
		}
		else if( IsSubStr( ent.current_scene, "headshot" ) )
		{
			// Snow impact in reverse.
			ent clientfield::set( "reverse_arrival_snow_fx", 1 );
			//waiting 1 second till raise up a bit for blood shot, needs notetrack to time right
			wait 1; 		
			ent clientfield::set( "reverse_arrival_dmg_fx", 1 );
		}
		else if ( IsSubStr( ent.current_scene, "forwardroll" ) )
		{			
			wait 2.5;  // explosion should occur when guy stands up
			ent clientfield::set( "reverse_arrival_explosion_fx", 1 );
		}
		else if ( IsSubStr( ent.current_scene, "backroll" ) )
		{			
			wait 2.75;  // explosion should occur when guy stands up
			ent clientfield::set( "reverse_arrival_explosion_fx", 1 );
		}			
	}	
}	


//*****************************************************************************
// s_bundle.scrint_string: optional goal.
//		- If the goal string has "volume" inside, then its a goal volume
//		- Otherwise its a goal node
// s_bundle.script_float: Optional goal radius once the AI gets to the target
// s_bundle.script_noteworthy - if set to "no_fallback".... You guessed it
//*****************************************************************************

// self = ai
function reverse_guy_goto_target_init( s_bundle )
{
	// Do we want to run to a target?
	if( IsDefined(s_bundle.script_string) )
	{
		radius = 1024;
		if( IsDefined(s_bundle.script_float) )
		{
			radius = s_bundle.script_float;
		}

		disable_fallback = 0;
		if( IsDefined(s_bundle.script_noteworthy) && (s_bundle.script_noteworthy == "no_fallback") )
		{
			disable_fallback = 1;
		}
			
		self thread reverse_guy_goto_target( s_bundle.script_string, s_bundle.scriptbundlename, radius, disable_fallback );
	}
}


//*****************************************************************************
//*****************************************************************************

// self = ai
function reverse_guy_goto_target( str_target, str_bundle_name, end_goal_radius, disable_fallback )
{
	self endon( "death" );
	wait( 1 );

	// Wait for the scene to stop playing
	while( 1 )
	{
		//if( !scene::is_playing(str_bundle_name) )
		if( !IsDefined(self.current_scene) )
		{
			break;
		}
		wait( 0.05 );
	}
	
	// Goto either a node or goal volume
	self.goalradius = 64;

	if( ( isdefined( disable_fallback ) && disable_fallback ) )
	{
		self.disable_fallback = 1;
	}

	if( IsSubStr( str_target, "volume" ) )
	{
		e_target = GetEnt( str_target, "targetname" );
		self setgoal( e_target );
	}
	else
	{
		nd_target = GetNode( str_target, "targetname" );
		self setgoal( nd_target.origin );
	}

	self waittill( "goal" );
	self.goalradius = end_goal_radius;
}


//*****************************************************************************
//*****************************************************************************

function callback_reverse_time_group_mg42_init( a_ents )
{
	// TODO: set up turret
}

function callback_reverse_time_group_mg42_play( a_ents )
{
	// TODO: enable turret firing
}


//*****************************************************************************
// Start with a trigger that targets a bundle
// - We play the bundle until the trigger is hit
// - The bundle now points to the next trigger bundle links
// - Now play the new bundle and wait for the next trigger
//*****************************************************************************

function sarah_objective_move( str_start_trigger, n_start, func_on_complete )
{
	//make sure old anchor not left behind
	old_anchor = GetEntArray( "sarah_objective_align", "targetname" );
	if( isdefined( old_anchor ) )
	{
		foreach( ent in old_anchor )
		{
			ent Delete();
		}	
	}			
			
	if( isdefined( n_start ) )
	{
		t_next = GetEnt( str_start_trigger + n_start, "targetname" );
		
		//system to force forward if necessary
		level.sarah_obj_trigs = objective_trigger_watcher_init( str_start_trigger, n_start );
		array::thread_all( level.sarah_obj_trigs, &objective_trigger_watcher, level.sarah_obj_trigs );
		
		//if starting further along the system for checkpoint, delete previous triggers.
		if( n_start > 0 )
		{
			for (i = 0; i < ( n_start - 1 ); i++)
			{
				t_removed = GetEnt( str_start_trigger + i, "targetname" );
				t_removed delete();
			}	
		}		
	}		

	s_objective_current = struct::get( t_next.target, "targetname" );

	ai_objective_sarah = util::get_hero( "sarah" );
	ai_objective_sarah ForceTeleport( s_objective_current.origin, s_objective_current.angles );
	ai_objective_sarah ai::set_ignoreall( true );
	ai_objective_sarah ai::set_ignoreme( true );
	ai_objective_sarah thread sarah_objective_marker();

	ai_objective_sarah.anchor = util::spawn_model("tag_origin", ai_objective_sarah.origin, ai_objective_sarah.angles);
	ai_objective_sarah.anchor.targetname = "sarah_objective_align";
	ai_objective_sarah linkto(ai_objective_sarah.anchor);	
	
	ai_objective_sarah.anchor thread scene::play( "cin_inf_00_00_sarah_vign_move_idle", ai_objective_sarah);
	
	while ( isdefined( t_next ) )
	{	
		t_next waittill( "trigger" );

		ArrayRemoveValue( level.sarah_obj_trigs, t_next );
		t_next Delete();

		n_start++;
		t_continue = GetEnt( str_start_trigger + n_start, "targetname" );

		if ( isdefined( t_continue ))
		{			
			t_next = t_continue;
			s_objective_old = s_objective_current;
			s_objective_current = struct::get( t_next.target, "targetname" );
			
			ai_objective_sarah thread sarah_objective_move_next( s_objective_current, s_objective_old );
		}
	}
	
	// move sarah to final endpoint, struct only target structs
	while( isdefined( s_objective_current.target ) )
	{
		s_objective_current = struct::get( s_objective_current.target, "targetname" );
	
		//setup speed 500 unit per second
		n_distance = Distance( ai_objective_sarah.anchor.origin, s_objective_current.origin );
		n_speed = 500;
		n_time = n_distance/n_speed;

		ai_objective_sarah.anchor MoveTo( s_objective_current.origin, n_time );
		ai_objective_sarah.anchor RotateTo( s_objective_current.angles, n_time );
		
		ai_objective_sarah thread sarah_moving_animations_start();

		ai_objective_sarah.anchor waittill("movedone");
	}		

	if( (ai_objective_sarah.anchor scene::is_playing()) )
	{
		ai_objective_sarah.anchor scene::stop();
	}

	ai_objective_sarah clientfield::set( "sarah_objective_light", 0 );
	util::wait_network_frame();

	ai_objective_sarah Unlink();
	ai_objective_sarah.anchor Delete();

	if ( IsDefined( func_on_complete ) )
	{
		ai_objective_sarah thread [[ func_on_complete ]]();
	}
}

//leaving hold position
function sarah_moving_animations_start()
{
	self.anchor endon( "death" );

	self.anchor scene::stop( "cin_inf_00_00_sarah_vign_move_idle" );//stop idle loop
	self.anchor scene::play( "cin_inf_00_00_sarah_vign_move_leave", self );//play leave
	self.anchor scene::play( "cin_inf_00_00_sarah_vign_move_moving", self );//after leave play moving
}

//arrived at new hold position
function sarah_moving_animations_stop( final_pos )
{
	self.anchor endon( "death" );
	
	//when get within a certain distance from final position start the enter animation
	while( Distance( self.origin, final_pos.origin ) > 512 )
	{
		wait 0.1;
	}	
	
	self.anchor scene::stop( "cin_inf_00_00_sarah_vign_move_moving" );//stop moving loop
	self.anchor scene::play( "cin_inf_00_00_sarah_vign_move_enter", self  );//play enter
	self.anchor scene::play( "cin_inf_00_00_sarah_vign_move_idle", self  );//play idle
}

//will handle movement to next position here.
function sarah_objective_move_next( pos, old_pos )
{
	//just incase got a call to move again
	while( ( isdefined( self.moving ) && self.moving ) )
	{
		wait 0.1;
	}
			
	self.moving = true;

	self thread sarah_moving_animations_start();
	self thread sarah_moving_animations_stop( pos );

	while( isdefined( old_pos.target ) )
	{
		old_pos = struct::get( old_pos.target, "targetname" );

		if( !isdefined( old_pos.angles ) )
		{
			old_pos.angles = (0, 0, 0);
		}
	
		//setup speed 500 unit per second
		n_distance = Distance( self.anchor.origin, old_pos.origin );
		n_speed = 300;
		n_time = n_distance/n_speed;
		
		self.anchor MoveTo( old_pos.origin, n_time );
		self.anchor RotateTo( old_pos.angles, n_time );

		self.anchor waittill("movedone");
		
		if( old_pos == pos )
		{
			break;
		}		
	}	
	self.moving = undefined;

}	

//self = sarah_objective
function sarah_objective_marker()
{
	self endon( "death" );

	while( isdefined( self ) )
	{
		if( self get_min_distance_players() > 3000 )
		{
			objectives::set( "cp_standard_breadcrumb" , self );
				
			while( Distance( level.players[0].origin, self.origin ) > 3000 )
			{
				wait 0.1;
			}

			objectives::complete( "cp_standard_breadcrumb" , self );
		}
		
		wait 1;		
	}	
}

function get_min_distance_players()
{
	n_dist = 10000;
	
	for(i = 0; i < level.players.size; i++ )
	{
		n_player_dist = Distance( level.players[I].origin, self.origin );
		if( n_player_dist < n_dist )
		{
			n_dist = n_player_dist;
		}
	}	
	return n_dist;
}

//function to find all triggers
function objective_trigger_watcher_init( str_start_trigger, n_start )
{
	a_t_next = [];
	
	while( true )
	{
		t_next = GetEnt( str_start_trigger + n_start, "targetname" );
		
		if( isdefined( t_next ) )
		{	
			t_next.t_num = n_start;
			array::add( a_t_next, t_next ); 
			n_start++;
		}
		else
		{
			return a_t_next;
		}		
	}
}

function objective_trigger_watcher( a_trigs )
{
	self endon( "death" );
	
	while( true )
	{
		self waittill( "trigger", who );
		if( IsPlayer( who ) )
		{
			for(i = 0; i < a_trigs.size; i++ )
			{
				if( isdefined( a_trigs[i] ) && ( a_trigs[i].t_num < self.t_num ) )
				{
					a_trigs[i] notify( "trigger" );
					util::wait_network_frame(); //so can catch up to next
				}		
			}	
			return;
		}		
	}
}	

//--------------------------------------------------------------------------------------------------
function enable_exploding_deaths( b_enabled = true, n_delay_time = 0 )
{
	level.exploding_deaths = b_enabled;
	level.exploding_deaths_delay_time = n_delay_time;
}

function exploding_deaths_enabled()
{
	if(!isdefined(level.exploding_deaths))level.exploding_deaths=false;
	
	return level.exploding_deaths;
}

function explode_on_ragdoll_start()
{
	self endon( "ai_explosion_death" );
	
	self waittill( "start_ragdoll" );
	
	death_explode_delay();
	
	if ( IsDefined( self ) )
	{
		self clientfield::set( "exploding_ai_deaths", 1 );
	}
	
	util::wait_network_frame();
	
	if ( IsDefined( self ) )
	{
		self Delete();
		self notify( "ai_explosion_death" );  // kill other explode thread
	}
}

function explode_when_actor_becomes_corpse()
{
	self endon( "ai_explosion_death" );
	
	self waittill( "actor_corpse", e_corpse );  // 'actor_corpse' sent when AI is deleted and is replaced with corpse entity
	
	death_explode_delay();
	
	if ( IsDefined( e_corpse ) )
	{
		e_corpse clientfield::set( "exploding_ai_deaths", 1 );
	}
	
	util::wait_network_frame();
	
	if ( IsDefined( e_corpse ) )
	{
		e_corpse Delete();	
	}
	
	if ( IsDefined( self ) )
	{
		self notify( "ai_explosion_death" );  // kill other explode thread
	}
}

function death_explode_delay()
{
	if ( IsDefined( level.exploding_deaths_delay_time ) )
	{
		wait level.exploding_deaths_delay_time;
	}	
}

function ai_death_explosions()  // self = AI
{	
	if ( self should_explode_on_death() )
	{
		// two different ways for guys to explode on death. internally, this will pick the fastest one
		self thread explode_when_actor_becomes_corpse();
		self thread explode_on_ragdoll_start();
	}		
}	

function should_explode_on_death()  // self = AI
{
	return ( !IsVehicle( self ) && exploding_deaths_enabled() && ( self.team != "allies" ) );
}

function delete_all_ai()
{
	a_ai = GetAITeamArray( "axis", "allies" );
	
	array::spread_all( a_ai, &_delete_if_defined );
}

function _delete_if_defined()
{
	if ( isdefined( self ) ) { self Delete(); };
}

function delete_ents_if_defined( str_targetname, str_key = "targetname" )
{
	a_ents = GetEntArray( str_targetname, str_key );
	
	array::spread_all( a_ents, &_delete_if_defined );
}

function callback_scene_objective_light_enable( a_ents )
{
	_callback_scene_objective_light( a_ents, true );
}

function callback_scene_objective_light_disable_no_delete( a_ents )
{
	_callback_scene_objective_light( a_ents, false );
}

function callback_scene_objective_light_disable( a_ents )
{
	_callback_scene_objective_light( a_ents, false );
	
	foreach( ent in a_ents )
	{
		if( IsSubStr( ent.targetname, "sarah" ) )
		{
			ai_objective_sarah = ent;
		}		
	}	

	if ( IsDefined( ai_objective_sarah ) )
	{
		ai_objective_sarah thread delete_sarah_when_done();
	}
}

//can't have wait in callback from scene
function delete_sarah_when_done()
{
	self ai::set_ignoreall( true );

	util::wait_network_frame();

	self util::self_delete();			
}	

function _callback_scene_objective_light( a_ents, b_show )
{
	foreach( ent in a_ents )
	{
		if( IsSubStr( ent.targetname, "sarah" ) )
		{
			ai_objective_sarah = ent;
		}		
	}	
	
	
	if ( IsDefined( ai_objective_sarah ) )
	{
		if ( IsAI( ai_objective_sarah ) )
		{
			ai_objective_sarah ai::set_ignoreme( true );
		}
		
		if( ( isdefined( b_show ) && b_show ) )
		{	
			ai_objective_sarah clientfield::set( "sarah_objective_light", 1 );
		}
		else
		{
			ai_objective_sarah clientfield::set( "sarah_objective_light", 0 );
		}	
	}
}

function setup_snow_triggers()
{
	array::spread_all( GetEntArray( "snow_disable", "script_noteworthy" ), &trigger_disable_snowfall );
}

// this scene is mostly for FX Anims, as they're in a shared prefab
function play_scene_on_trigger( str_scene, str_trigger_value, str_trigger_key = "targetname", b_init_at_start = true )
{
	Assert( IsDefined( str_scene ), "play_scene_on_trigger: str_scene is missing!" );
	Assert( IsDefined( str_trigger_value ), "play_scene_on_trigger: str_trigger_value is missing!" );

	// function should not block
	self thread _play_scene_on_trigger( str_scene, str_trigger_value, str_trigger_key, b_init_at_start );
}

function _play_scene_on_trigger( str_scene, str_trigger_value, str_trigger_key, b_init_at_start )
{
	if ( b_init_at_start )
	{
		self scene::init( str_scene );
	}
	
	trigger::wait_till( str_trigger_value, str_trigger_key, undefined, true );  // should assert if missing
	
	self scene::play( str_scene );
}

function play_scene_on_view_and_radius( str_scene, str_lookat, str_trigger_inner, str_trigger_outter, b_init_at_start = true )
{
	if ( b_init_at_start )
	{
		self scene::init( str_scene );
	}
	
	self thread _play_scene_on_view_and_radius( str_scene, str_lookat, str_trigger_inner, str_trigger_outter, b_init_at_start );
}

function _play_scene_on_view_and_radius( str_scene, str_lookat, str_trigger_inner, str_trigger_outter, b_init_at_start )
{
	t_inner = GetEnt( str_trigger_inner, "targetname" );
	t_outter = GetEnt( str_trigger_outter, "targetname" );
	s_lookat = struct::get( str_lookat, "targetname" );
	e_player = level.players[0];
	
	while ( true )
	{
		trigger::wait_till( str_trigger_outter, "targetname", undefined, true );
		
		if( level.players.size == 1 )
		{
			if( ( e_player LookingAtStructDuration( s_lookat, t_inner, t_outter, 1 ) ) || ( e_player IsTouching( t_inner ) ) )
			{
				self thread scene::play( str_scene );
				
				t_inner Delete();
				t_outter Delete();
				break;
			}
			
		}
		else
		{
			self thread scene::play( str_scene );
				
			t_inner Delete();
			t_outter Delete();
			break;
		}
		
		util::wait_network_frame();
	}
}

function IsBetweenInnerOutter( t_inner, t_outter )
{
	// self = player
	if ( ( self IsTouching( t_outter ) ) && ( !self IsTouching( t_inner ) ) )
	{
		return true;
	}
	else
	{
		return false;
	}
}

function IsLookingAtStruct( s_lookat )
{	
	self endon( "death" );
	self endon ( "disconnect" );

	if( !isdefined( self ) || !isdefined( s_lookat ) )
	{
		return false;
	}		
	
	// self = player
	v_dir = s_lookat.origin - self.origin;
	v_dir = VectorNormalize( v_dir );
	v_forward = AnglesToForward( self.angles );
	
	dp = VectorDot( v_dir, v_forward );
	if( dp > 0.87 )
	{
		return true;
	}
	else
	{
		return false;
	}
}

function LookingAtStructDuration( s_lookat, t_inner, t_outter, n_duration )
{
	self endon( "death" );
	self endon ( "disconnect" );

	// self = player
	n_time = 0;
	
	b_radius_check = IsBetweenInnerOutter( t_inner, t_outter);
	b_lookat_check = IsLookingAtStruct( s_lookat );
	
	while ( b_radius_check && b_lookat_check && ( n_time < n_duration ) )
	{
		b_radius_check = IsBetweenInnerOutter( t_inner, t_outter);
		b_lookat_check = IsLookingAtStruct( s_lookat );
		
		wait 0.1;
		
		n_time += 0.1;
	}
	
	if ( b_radius_check && b_lookat_check && n_time >= n_duration )
		return true;
	else
		return false;
}

function LookingAtStructDurationCheck( str_lookat, n_duration, str_notfiy, n_max_distance = undefined )
{
	self endon( "death" );
	self endon ( "disconnect" );
	
	
	s_lookat = struct::get( str_lookat, "targetname" );
	
	while ( true )
	{
		if ( self LookingAtStructDurationOnly( s_lookat, n_duration, n_max_distance ) ) 
		{
			level notify( str_notfiy );
			break;
		}
		
		util::wait_network_frame();
	}
}

function IsWithinMaxDistance( s_lookat, n_max_distance )
{
	if ( IsDefined( n_max_distance ) )
	{
		if ( Distance2D( self.origin, s_lookat.origin ) < n_max_distance )
		{
			return true;
		}
		else
		{
			return false;
		}
	}
	else
	{
		return true;
	}
}

function LookingAtStructDurationOnly( s_lookat, n_duration, n_max_distance )
{
	self endon( "death" );
	self endon ( "disconnect" );
		
	// self = player
	n_time = 0;
	
	b_lookat_check = IsLookingAtStruct( s_lookat );
	b_distance_check = IsWithinMaxDistance( s_lookat, n_max_distance );
	
	while ( b_lookat_check && b_lookat_check && ( n_time < n_duration ) )
	{
		b_lookat_check = IsLookingAtStruct( s_lookat );
		b_distance_check = IsWithinMaxDistance( s_lookat, n_max_distance );
		
		wait 0.1;
		
		n_time += 0.1;
	}
	
	if ( b_lookat_check && b_distance_check && ( n_time >= n_duration ) )
		return true;
	else
		return false;
}

function pull_out_last_weapon()
{
	if( IsDefined(self.lastActiveWeapon) && (self.lastActiveWeapon != level.weaponNone) && self HasWeapon( self.lastActiveWeapon ) )
	{
		self SwitchToWeapon( self.lastActiveWeapon );
	}
	else
	{
		primaryWeapons = self GetWeaponsListPrimaries();
		if( IsDefined( primaryWeapons ) && primaryWeapons.size > 0 )
		{
			self SwitchToWeapon( primaryWeapons[0] );
		}
	}
}

function player_enter_cinematic()
{
	self SetLowReady( true );
	self AllowJump( false );
	self AllowSprint( false );
	self AllowProne( false );		
	self EnableInvulnerability();
}

function player_leave_cinematic()
{
	self SetLowReady( false );
	self AllowJump( true );
	self AllowSprint( true );
	self AllowProne( true );		
	self DisableInvulnerability();
}	

function monitor_spawner_and_trigger_reinforcement( str_spawner_source, str_spawner_reinforce, str_volume, n_wait, n_count )
{
	while ( true )
	{
		if ( spawn_manager::is_enabled( str_spawner_source ) )
		{
			wait n_wait;
			spawn_by_min_ai_in_volume( str_spawner_reinforce, str_volume, n_count );
			break;
		}
		
		util::wait_network_frame();
	}
}

function spawn_by_min_ai_in_volume( str_spawner, str_volume, n_count )
{
	while (true)
	{
		a_ai = GetAITeamArray( "axis" );
		
		e_volume = GetEnt( str_volume, "targetname" );
		
		a_ai_in_volume = [];
		
		if ( IsDefined( e_volume) )
		{
			if ( a_ai.size > 0 )
			{
				foreach ( ai in a_ai )
				{
					if ( ai IsTouching( e_volume ) )
					{
						a_ai_in_volume[ a_ai_in_volume.size ] = ai;
					}
				}
			}
		}
		
		if ( a_ai_in_volume.size <= n_count )
		{
			spawn_manager::enable( str_spawner );
			break;
		}
		
		util::wait_network_frame();
	}
}

// ----------------------------------------------------------------------------
//	set_ai_goto_volume
// ----------------------------------------------------------------------------
function set_ai_goto_volume( e_volume )
{
	self endon ( "death" );
	
	// self = ai
	self.goalradius = 128;
	self setgoal( e_volume );
	self waittill( "goal" );
	self.goalradius = 1024;
}

// ----------------------------------------------------------------------------
//	set_ai_goal_volume
// ----------------------------------------------------------------------------
function set_ai_goal_volume( str_ai_name, str_goal_volume_name )
{
	e_retreat_goal_volume = GetEnt( str_goal_volume_name, "targetname" );
	
	a_enemies = GetAIArray( str_ai_name, "targetname" );
	
	foreach ( e_enemy in a_enemies )
	{
		if ( IsAlive( e_enemy ) )
		{			
			e_enemy thread set_ai_goto_volume( e_retreat_goal_volume );
		}
		
		util::wait_network_frame();
	}
}

function retreat_if_in_volume( str_current_volume, str_next_volume )
{
	a_enemies = GetAITeamArray( "axis" );
		
	e_current_volume = GetEnt( str_current_volume, "targetname" );
	e_next_volume = GetEnt( str_next_volume, "targetname" );
		
	if ( IsDefined( e_current_volume) && IsDefined( e_next_volume) )
	{
		foreach ( e_enemy in a_enemies )
		{
			if ( IsAlive( e_enemy ) )
			{
				if ( e_enemy IsTouching( e_current_volume ) )
				{
					e_enemy thread set_ai_goto_volume( e_next_volume );					
				}
			}
						
			util::wait_network_frame();
		}
	}
}

//*****************************************************************************
//*****************************************************************************

function CreateClientHudText( e_player, str_message, x_off, y_off, font_scale )
{
	font_color = ( 1.0, 1.0, 1.0 );
	
	hud_elem = e_player create_client_hud_elem( "center", "middle", "center", "top", x_off, y_off, font_scale, font_color, str_message );
				 
	return( hud_elem );
}

// self = the player
function create_client_hud_elem( alignX, alignY, horzAlign, vertAlign, xOffset, yOffset, fontScale, color, str_text )
{
	hud_elem = NewClientHudElem( self );
	hud_elem.elemType = "font";
	hud_elem.font = "objective";
	hud_elem.alignX = alignX;
	hud_elem.alignY = alignY;
	hud_elem.horzAlign = horzAlign;
	hud_elem.vertAlign = vertAlign;
	hud_elem.x += xOffset;
	hud_elem.y += yOffset;
	hud_elem.foreground = true;
	hud_elem.fontScale = fontScale;
	hud_elem.alpha = 1;
	hud_elem.color = color;
	hud_elem.hidewheninmenu = true;
	hud_elem SetText( str_text );
	return hud_elem;
}

function player_can_see_me( dist )
{
	if(!isdefined( dist ))
	{
		dist = 512;
	}		


	for( i = 0; i < level.players.size; i++ )
	{
		if(!isdefined(self))
		{
			return false;
		}		

		if(!isdefined(level.players[i]))
		{
			continue;
		}		
		
		PlayerAngles = level.players[i] GetPlayerAngles();
		PlayerForwardVec = AnglesToForward( PlayerAngles );
		PlayerUnitForwardVec = VectorNormalize( PlayerForwardVec );
	
		BanzaiPos = self.origin;
		PlayerPos = level.players[i] GetOrigin();
		PlayerToBanzaiVec = BanzaiPos - PlayerPos;
		PlayerToBanzaiUnitVec = VectorNormalize( PlayerToBanzaiVec );
	
		ForwardDotBanzai = VectorDot( PlayerUnitForwardVec, PlayerToBanzaiUnitVec );
	
		if ( ForwardDotBanzai >= 1 )
		{
			AngleFromCenter = 0;
		}
		else if ( ForwardDotBanzai <= -1 )
		{
			AngleFromCenter = 180;
		}
		else
		{
			AngleFromCenter = ACos( ForwardDotBanzai ); 
		}
	
		PlayerFOV = GetDvarFloat( "cg_fov" );
		BanzaiVsPlayerFOVBuffer = GetDvarFloat( "g_banzai_player_fov_buffer" );	
		if ( BanzaiVsPlayerFOVBuffer <= 0 )
		{
			BanzaiVsPlayerFOVBuffer = 0.2;
		}
		
		PlayerCanSeeMe = ( AngleFromCenter <= ( PlayerFOV * 0.5 * ( 1 - BanzaiVsPlayerFOVBuffer ) ) );
	
		//can be seen or too close
		if(( isdefined( PlayerCanSeeMe ) && PlayerCanSeeMe ) || (Distance(level.players[i].origin, self.origin) < dist ) )
		{	
			return true;
		}
	}
	return false;	
}

// ----------------------------------------------------------------------------
//	model_ghost
// ----------------------------------------------------------------------------
function models_ghost( a_models )
{
	foreach ( model in a_models )
	{
		model Ghost();
	}
}

// ----------------------------------------------------------------------------
//	model_show
// ----------------------------------------------------------------------------
function models_show( a_models )
{
	foreach ( model in a_models )
	{
		model Show();
	}
}


// ----------------------------------------------------------------------------
//	adjust_sunshadowsplitdistance
// ----------------------------------------------------------------------------

function adjust_sunshadowsplitdistance()
{
	level.old_sunshadowsplitdistance = level.sun_shadow_split_distance;

	// SET THE SUNSHADOWSPLITDISTANCE	
	level util::set_sun_shadow_split_distance( 5000 );
}

// ----------------------------------------------------------------------------
//	adjust_sunshadowsplitdistance
// ----------------------------------------------------------------------------
function reset_sunshadowsplitdistance()
{
	if( IsDefined( level.old_sunshadowsplitdistance ) )
	{
		level util::set_sun_shadow_split_distance( level.old_sunshadowsplitdistance );
	}
}

//--------------------------------------------------------------------------------------------------
//		ZOMBIE VOCALS SCRIPT (from _zm_audio.gsc)
//--------------------------------------------------------------------------------------------------
function zmbAIVox_NotifyConvert()
{
	self endon ( "death" );
	self endon ( "disconnect" );
	level endon ( "game_ended" );
	
	self thread zmbAI_PlaySprintVox();
	self thread zmbAIVox_PlayDeath();

	while (1)
{
		self waittill("bhtn_action_notify", notify_string);
		
		switch( notify_string )
		{					
			case "death":
			case "behind":
			case "attack_melee":
			case "electrocute":
			case "close":
				level thread zmbAIVox_PlayVox( self, notify_string, true );
				break;
			case "teardown":
			case "taunt":
			case "ambient":
			case "sprint":
			case "crawler":
				level thread zmbAIVox_PlayVox( self, notify_string, false );
				break;
			default:
			{
				if ( IsDefined( level._zmbAIVox_SpecialType ) )
				{
					if( isdefined( level._zmbAIVox_SpecialType[notify_string] ) )
					{
						level thread zmbAIVox_PlayVox( self, notify_string, false );
					}
				}
				break;
			}
		}
	}
}
function zmbAIVox_PlayVox( zombie, type, override )
{
    zombie endon( "death" ); 
    
    if( !isdefined( zombie ) )
    	return;
    
    if( !isdefined( zombie.voicePrefix ) )
    	return; 
    
    alias = "zmb_vocals_" + zombie.voicePrefix + "_" + type;
    
    if( sndIsNetworkSafe() )
    {
	    if( ( isdefined( override ) && override ) )
	    {
	   		zombie PlaySound( alias );
	    }
	    else if( !( isdefined( zombie.talking ) && zombie.talking ) )
	    {
	        zombie.talking = true;
	        
	        zombie PlaySoundWithNotify( alias, "sounddone" );
	        zombie waittill( "sounddone" );
	        zombie.talking = false;
	    }
    }
}
function zmbAIVox_PlayDeath()
{
	self endon ( "disconnect" );
	
	self waittill ( "death", attacker, meansOfDeath );
	
	if ( isdefined( self ) )
	{	
		level thread zmbAIVox_PlayVox( self, "death", true );
	}
}
function zmbAI_PlaySprintVox()
{
	self endon ( "death" );
	self endon ( "disconnect" );
	
	wait(randomfloatrange(1,3));
	
	while(1)
	{
		self notify( "bhtn_action_notify", "sprint" );
		wait(randomfloatrange(1.5,3));
	}
}
function networkSafeReset()
{
	while(1)
	{
		level._numZmbAIVox = 0;
		util::wait_network_frame();
	}
}
function sndIsNetworkSafe()
{
	if ( !IsDefined( level._numZmbAIVox ) )
	{
	 	level thread networkSafeReset();
	}

	if ( level._numZmbAIVox > 4 )
	{
	  	return false;
	}

	level._numZmbAIVox++;
	return true;
}

//SELF is Player
function zombie_behind_vox()
{
	level endon( "zombies_completed" );
	self endon("death_or_disconnect");
	
	level waittill( "start_zombie_sequence" );
	
	if(!IsDefined(level._zbv_vox_last_update_time))
	{
		level._zbv_vox_last_update_time = 0;	
		level._audio_zbv_shared_ent_list = GetAiTeamArray( "axis" );
	}
	
	while(1)
	{
		wait(1);		
		
		t = GetTime();
		
		if(t > level._zbv_vox_last_update_time + 1000)
		{
			level._zbv_vox_last_update_time = t;
			level._audio_zbv_shared_ent_list = GetAiTeamArray( "axis" );
		}
		
		zombs = level._audio_zbv_shared_ent_list;
		
		played_sound = false;
		
		for(i=0;i<zombs.size;i++)
		{
			if(!isDefined(zombs[i]))
			{
				continue;
			}
							
			if(DistanceSquared(zombs[i].origin,self.origin) < 250 * 250 )
			{				
				yaw = self GetYawToSpot(zombs[i].origin );
				z_diff = self.origin[2] - zombs[i].origin[2];
				if( (yaw < -95 || yaw > 95) && abs( z_diff ) < 50 )
				{
					zombs[i] notify( "bhtn_action_notify", "behind" );
					played_sound = true;
					break;
				}			
			}
		}
		
		if(played_sound)
		{
			wait(5);		// Each player can only play one instance of this sound every 5 seconds - instead of the previous network storm.
		}
	}
}
function GetYawToSpot(spot)
{
	pos = spot;
	yaw = self.angles[1] - GetYaw(pos);
	yaw = AngleClamp180( yaw );
	return yaw;
}
function GetYaw(org)
{
	angles = VectorToAngles(org-self.origin);
	return angles[1];
}

//*****************************************************************************
//*****************************************************************************

function player_distance( pos )
{
	closest_dist = 99999.9;

	a_players = GetPlayers();
	for( i=0; i<a_players.size; i++ )
	{
		dist = distance( a_players[i].origin, pos );
		if( dist < closest_dist )
		{
			closest_dist = dist;
		}
	}

	return( closest_dist );
}

//--------------------------------------------------------------------------------------------------
//		POSTFX and movie transitions
//--------------------------------------------------------------------------------------------------
function movie_transition( str_movie_name )
{
	level post_fx_transitions( "dni_futz", str_movie_name );
}

function post_fx_transitions( str_pstfx, str_movie_name, b_trans_out = true )
{
   	a_postfx_field = [];
	a_postfx_field[ "dni_interrupt" ] = "postfx_dni_interrupt";
	a_postfx_field[ "dni_futz" ] = "postfx_futz";
	
	assert( isdefined( a_postfx_field[str_pstfx] ), "Called post_fx_transitions with a postfx name that doesn't exist: " + str_pstfx );
	
	foreach( player in level.players )
	{
		player clientfield::increment_to_player( a_postfx_field[str_pstfx], 1 );
	}
	
	if( isdefined( str_movie_name ) )
	{
		wait 1.0; //LET THE POSTFX PLAY FOR A BIT
		lui::play_movie( str_movie_name, "fullscreen" );
		
		if( b_trans_out )
		{
			foreach( player in level.players )
			{
				player clientfield::increment_to_player( a_postfx_field[str_pstfx], 1 );
			}		
		}
	}
}


//--------------------------------------------------------------------------------------------------
//		POSTFX and movie transitions
//		self is an actor
//--------------------------------------------------------------------------------------------------
function actor_camo( n_camo_state, b_use_spawn_fx = true )
{
	self endon( "death" );
	
	if( ( isdefined( b_use_spawn_fx ) && b_use_spawn_fx ) ) //flicker and spawn, if false imediately goes on or off
	{	
		self clientfield::set( "sarah_camo_shader", 2 );
		self clientfield::set( "sarah_spawn_fx", 1 );
			
		wait 2; //flicker for a before turning off/on
	}
	
	self clientfield::set( "sarah_camo_shader", n_camo_state );
	
	if ( n_camo_state == 1 )
	{
		self ai::set_ignoreme( true );
	}
	else
	{
		self ai::set_ignoreme( false );
		self notify ( "actor_camo_off" );
	}
	
	//clear fx client
	self clientfield::set( "sarah_spawn_fx", 0 );
}


//*****************************************************************************
// Waits for ANY player to run past the struct
// - Uses the forward vector of the struct against the direction to the player (dp)
//*****************************************************************************

function wait_for_any_player_to_pass_struct( str_struct )
{
	s_struct = struct::get( str_struct, "targetname" );
	v_struct_dir = anglestoforward( s_struct.angles );

	player_close = 0;
	while( !player_close )
	{
		a_players = getplayers();
		for( i=0; i<a_players.size; i++ )
		{
			e_player = a_players[i];
			v_dir = vectornormalize( e_player.origin - s_struct.origin );
			dp = vectordot( v_dir, v_struct_dir );
			if( dp > 0.0 )
			{
				player_close = 1;
				break;
			}
		}
		wait( 0.05 );
	}
}


//*****************************************************************************
// Waits for ALL players to run past the struct
// - Uses the forward vector of the struct against the direction to the player (dp)
//*****************************************************************************

function wait_for_all_players_to_pass_struct( str_struct )
{
	s_struct = struct::get( str_struct, "targetname" );
	v_struct_dir = anglestoforward( s_struct.angles );

	while( 1 )
	{
		num_players_past = 0;

		a_players = getplayers();
		for( i=0; i<a_players.size; i++ )
		{
			e_player = a_players[i];
			v_dir = vectornormalize( e_player.origin - s_struct.origin );
			dp = vectordot( v_dir, v_struct_dir );
			if( dp > 0.0 )
			{
				num_players_past++;
			}
		}

		if( num_players_past == a_players.size )
		{
			break;
		}

		wait( 0.05 );
	}
}


//*****************************************************************************
// Cleanup all the ends with the specified cleanup name
//*****************************************************************************

function cleanup_group_add( e_ent, str_cleanup_group_name )
{
	e_ent.cleanup_group = str_cleanup_group_name;
}


//*****************************************************************************
//*****************************************************************************

function cleanup_group_kill( str_cleanup_group_name, do_death )
{
	a_ai = GetAIArray();
	if( IsDefined(a_ai) )
	{
		for( i=0; i<a_ai.size; i++ )
		{
			e_ent = a_ai[i];
			if( Isdefined(e_ent.cleanup_group) && (e_ent.cleanup_group == str_cleanup_group_name) )
			{
				if( do_death )
				{
					e_ent kill();
				}
				else
				{
					e_ent delete();
				}
			}
		}
	}
}


//*****************************************************************************
// Return a sorted array of ents with with by closest to the players
//*****************************************************************************

function ent_array_distance_from_players( a_ents )
{
	a_sorted_ents = [];

	a_players = getplayers();


	while( a_ents.size > 0 )
	{
		e_closest = undefined;
		n_closest = 999999.9;
		for( i=0; i<a_ents.size; i++ )
		{
			// Get distance from players
			n_player_dist = 999999.9;
			for( np=0; np<a_players.size; np++ )
			{
				dist = distance( a_players[np].origin, a_ents[i].origin );
				if( dist < n_player_dist )
				{
					n_player_dist = dist;
				}
			}

			// Is the ent the closest so far?
			if( n_player_dist < n_closest )
			{
				n_closest = n_player_dist;
				e_closest = a_ents[i];
			}
		}

		// Add the closest ent
		a_sorted_ents[ a_sorted_ents.size ] = e_closest;

		// Remove the ent from the original array
		ArrayRemoveValue( a_ents, e_closest );
	}

	return( a_sorted_ents );
}


//*****************************************************************************
//	foy_battle_chatter
//*****************************************************************************

function infection_battle_chatter( vo_spoken )
{
	a_ai_array = GetAiTeamArray( "allies" );
	a_speaker = array::get_closest ( level.players[0].origin, a_ai_array );
	
	if( IsDefined( a_speaker ) )
	{
		a_speaker Notify( "scriptedBC", vo_spoken );
	}
}



function igc_begin()
{
	foreach( e_player in level.players )
	{
		e_player Freezecontrols( true );
		e_player setClientUIVisibilityFlag( "hud_visible", 0 );
		e_player DisableWeapons();
	}

	SetDvar( "debug_show_viewpos", "0" ); 

	SetDvar( "cg_draw2D", 0 );
	SetDvar( "cg_drawFPS", 0 );
	SetDvar( "cg_drawPerformanceWarnings", 0 );
}

function igc_end()
{
	SetDvar( "debug_show_viewpos", "1" ); 		

	SetDvar( "cg_draw2D", 1 );
	SetDvar( "cg_drawFPS", 2 );
	SetDvar( "cg_drawPerformanceWarnings", 1 );	

	foreach ( e_player in level.players )
	{
		e_player Freezecontrols( false );
		e_player setClientUIVisibilityFlag( "hud_visible", 1 );
		e_player EnableWeapons();
	}
}


