#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\compass;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\ai_shared;
#using scripts\shared\colors_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\math_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\flagsys_shared;

#using scripts\shared\ai\robot_phalanx;
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	           	              	           	                                                                                                                                                                                                                                                                                             

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\cp\_load;
#using scripts\cp\_skipto;
#using scripts\cp\_util;
#using scripts\cp\_oed;
#using scripts\cp\_debug;
#using scripts\cp\_spawn_manager;

#precache( "lui_menu", "HeroSlotActivateTutorial" );
#precache( "lui_menu", "SpikeLauncherDetonateTutorial" );
#precache( "lui_menu", "TurretTakeTutorial" );
	
 // TODO: need real design solution for this weapon
	
// Start ramses_util
#namespace ramses_util;

function autoexec __init__sytem__() {     system::register("ramses_util",&__init__,undefined,undefined);    }
	
function __init__()
{
	// Lighting
	clientfield::register( "toplayer", "ramses_sun_color", 1, 1, "int" );	
	
	//postfx for dni interruption
	clientfield::register( "toplayer", "postfx_dni_interrupt", 1, 1, "counter" );
	clientfield::register( "toplayer", "postfx_futz", 1, 1, "counter" );
}

// default is 0
function is_demo()
{
	return GetDvarInt( "is_demo_build", false );
}

function prepare_players_for_demo_warp()
{
	foreach ( player in level.players )
	{
		if ( player IsInVehicle() )
		{
			vh_occupied = player GetVehicleOccupied();
			n_seat = vh_occupied GetOccupantSeat( player );
			
			vh_occupied UseVehicle( player, n_seat );  // make player exit vehicle
		}
	}
}

// Self is a player or an array of players
function set_low_ready( b_enable = true )
{
	if( !IsArray( self ) )
	{
		a_e_players = Array( self );
	}
	else
	{
		a_e_players = self;
	}
	
	foreach( e_player in a_e_players )
	{
		e_player SetLowReady( b_enable );
	}
}

function delete_ent_array( str_value, str_key = "targetname" )
{
	level thread _delete_ent_array( str_value, str_key );
}

function _delete_ent_array( str_value, str_key )
{
	const MAX_DELETE_PER_FRAME = 3;
	
	a_ents = GetEntArray( str_value, str_key );
	
	foreach ( i, ent in a_ents )
	{
		if ( i % MAX_DELETE_PER_FRAME )
		{
			{wait(.05);};
		}
		
		if ( isdefined( ent ) ) { ent Delete(); };
	}	
}

/***********************************
 * DEAD SYSTEM
 * ********************************/

// DEAD TURRETS spawn @ level start
//				delete @ arena_defend
//				spawn again @ subway
function init_dead_turrets( b_fake_rs_turrets = false )
{
	level.a_e_dead_turrets_non_controllable = [];
	
	// Set Up Non-Controllable Dead Turrets
	a_sp_turret_non_controllable = GetEntArray( "dead_turrets_non_controllable", "targetname" );
	
	if( b_fake_rs_turrets )
	{
		foreach( sp_turret in a_sp_turret_non_controllable )
		{
			m_turret = spawn( "script_model", sp_turret.origin );
			m_turret.angles = sp_turret.angles;
			m_turret SetModel( "veh_t7_turret_dead_system_ramses" );
		}
	}
	else
	{
		foreach( sp_turret in a_sp_turret_non_controllable )
		{
			e_dead_turret = spawner::simple_spawn_single( sp_turret );
			
			level.a_e_dead_turrets_non_controllable[level.a_e_dead_turrets_non_controllable.size] = e_dead_turret;
			e_dead_turret.takedamage = false;
		}
	}
	
	// Spawn the controllable DEAD Turrets
	level.a_e_dead_turrets = [];
	
	// Set Up Controllable Dead Turrets
	a_sp_turret = GetEntArray( "dead_turrets", "script_noteworthy" );
	foreach( sp_turret in a_sp_turret )
	{
		e_dead_turret = spawner::simple_spawn_single( sp_turret );
		
		level.a_e_dead_turrets[level.a_e_dead_turrets.size] = e_dead_turret;
		e_dead_turret.dead_turret_owned = false;
		e_dead_turret.takeDamage = false;
		
		// Extra Settings so Turrets can be used by VTOL RIDE vignettes
		if( IsDefined( sp_turret.script_int ) )
		{
			Assert( IsDefined( e_dead_turret.script_int ), "Level script attempting to overwrite script_int on a Dead Turret" );
			
			e_dead_turret.script_int = sp_turret.script_int;
		}
	}
	
	level.a_e_all_dead_turrets = arraycombine( level.a_e_dead_turrets, level.a_e_dead_turrets_non_controllable, true, false );
}

function delete_all_dead_turrets()
{
	level notify( "stop_rs_dead_turret_vignettes" );
	
	if( IsDefined( level.a_e_all_dead_turrets ) )
	{
		foreach( e_turret in level.a_e_all_dead_turrets )
		{
			e_turret delete();
		}
	}
	
	level.a_e_dead_turrets_non_controllable = undefined;
	level.a_e_dead_turrets = undefined;
	level.a_e_all_dead_turrets = undefined;
}

/***********************************
 * HIDE/SHOW
 * ********************************/

// Self is array of ents
function hide_ents( b_connect = false )
{ 
	foreach( e in self )
	{
		e Hide();
	}
	if( b_connect )
	{
		foreach( e in self )
		{
			e ConnectPaths();
		}
	}
}

// Self is array of ents
function show_ents( b_disconnect = false )
{
	foreach( e in self )
	{
		e Show();
	}
	
	if( b_disconnect )
	{
		foreach( e in self )
		{
			if( e.targetname !== "path_neutral" ) //-- these ents are grabbed by script noteworthy
			{
				if( isdefined(e.script_noteworthy) && e.script_noteworthy == "connect_paths" ) //Added because some entities need to ConnectPaths when shown
				{
					e ConnectPaths();
				}
				else
				{
					//-- There are only certain entities that we want to disconnect paths on
					if( isdefined( e.classname ) && ( e.classname == "script_brushmodel" || ( e.classname == "script_model" && ( e.model == "p7_cai_stacking_cargo_crate" || e.model == "veh_t7_mil_vtol_dropship_troopcarrier" ) ) ) )
					{
						e DisconnectPaths();
					}
				}
			}
		}
	}
}

// self is an array of structs
function spawn_from_structs( )
{
	const MAX_SPAWNS_PER_FRAME = 10;
	n_count = 0;
	
	foreach( struct in self )
	{
		if(IsDefined( struct.model) )
		{
			new_ent = Spawn( "script_model", struct.origin );
			new_ent.angles = struct.angles;
			new_ent SetModel( struct.model );
			n_count++;
			
			if( n_count % MAX_SPAWNS_PER_FRAME == 0 )
			{
				util::wait_network_frame();
			}
		}
	}
}

// Self is array of ents
// Make ents not solid
// optionally connect paths, default is false
// optionally make moving platform, default is undefined
function make_not_solid( b_moving )
{
	if( IsArray( self ) )
	{
		a_e = self;
	}
	else
	{
		a_e = Array( self );
	}
	foreach( e in a_e )
	{
		e NotSolid();
	}
	if( isdefined( b_moving ) )
	{
		foreach( e in a_e )
		{
			e SetMovingPlatformEnabled( b_moving );
		}
	}
}

// Self is array of ents
// Make ents solid
// optionally disconnect paths, default is false
// optionally make moving platform, default is undefined
function make_solid( b_moving )
{
	if( IsArray( self ) )
	{
		a_e = self;
	}
	else
	{
		a_e = Array( self );
	}
	
	foreach( e in a_e )
	{
		e Solid();
	}
	if( isdefined( b_moving ) )
	{
		foreach( e in a_e )
		{
			e SetMovingPlatformEnabled( b_moving );
		}
	}
}

// Self is a player or an array of players
function set_visible( str_ent, b_visible = true )
{
	a_e_invis = GetEntArray( str_ent, "targetname" );
	a_e_players = self;
	if( !IsArray( self ) )
	{
		a_e_players = Array( self );
	}
	
	if( b_visible )
	{
		foreach( e_player in a_e_players )
		{
			foreach( e_invis in a_e_invis )
			{
				e_invis SetVisibleToPlayer( e_player );
			}
		}
	}
	else
	{
		foreach( e_player in a_e_players )
		{
			foreach( e_invis in a_e_invis )
			{
				e_invis SetInvisibleToPlayer( e_player );
			}
		}
	}
}

/***********************************
 * SPIKE LAUNCHER
 * ********************************/

// Give--------------

// Self is a player or an array of players
function give_spike_launcher( b_force_switch = true, b_hint = true )
{
	//-- If the mobile armory is running then exit, the armory handles keeping hero weapons	
	if( flagsys::get("mobile_armory_in_use") )
	{
		return;	
	}
	
	a_e_players = self;
	if( !IsArray( a_e_players ) )
	{
		a_e_players = Array( a_e_players );
	}
	w_spike_launcher = GetWeapon( "spike_launcher" );
	
	foreach( e_player in a_e_players )
	{
		e_player GiveWeapon( w_spike_launcher );
		e_player SetWeaponAmmoClip( w_spike_launcher, w_spike_launcher.clipSize );
		e_player GiveMaxAmmo( w_spike_launcher );
		if( b_force_switch )
		{
			e_player SwitchToWeapon( w_spike_launcher );
		}
		
		if( b_hint )
		{
			e_player thread spike_launcher_tutorial_hint( w_spike_launcher );
		}
	}
}

// Hint--------------

// Self is a player
function spike_launcher_tutorial_hint( w_spike_launcher )
{
	self endon( "bled_out" );
	self endon( "disconnect" );
	
	while( !self flag::get( "spike_launcher_tutorial_complete" ) )
	{
		self waittill( "weapon_change_complete", w_current );
		if(  w_current == w_spike_launcher )
		{
			self _wait_till_tutorial_complete( w_spike_launcher );
		}
	}
}

// Self is a player
function _wait_till_tutorial_complete( w_spike_launcher )
{
	self endon( "bled_out" );
	self endon( "disconnect" );
	
	self waittill( "weapon_fired", w_current );
	if( w_current == w_spike_launcher )
	{
		hint = self OpenLUIMenu( "SpikeLauncherDetonateTutorial" );
		self wait_till_detonate_button_pressed();
		self CloseLUIMenu( hint );
	}
}

// Self is a player
function wait_till_detonate_button_pressed()
{
	self endon( "disconnect" );
	self endon( "weapon_switch_started" );
	
	while( !self MeleeButtonPressed() )
	{
		wait .1;
	}
	self flag::set( "spike_launcher_tutorial_complete" );
}


// Take--------------
// Self is a player or an array of players
function take_spike_launcher()
{
	a_e_players = self;
	if( !IsArray( a_e_players ) )
	{
		a_e_players = Array( a_e_players );
	}
	w_spike_launcher = GetWeapon( "spike_launcher" );
	
	foreach( e_player in a_e_players )
	{
		if( e_player HasWeapon( w_spike_launcher ) )
		{
			e_player TakeWeapon( w_spike_launcher );	
		}
	}
}

/***********************************
 * COOP
 * ********************************/

// Self is spawn manager
function scale_spawn_manager_by_player_count( n_count_per_player, n_active_max_per_player, n_active_min_per_player )
{
	b_something_to_scale = isdefined( n_count_per_player ) || isdefined( n_active_max_per_player ) || isdefined( n_active_min_per_player );
	Assert( ( isdefined( b_something_to_scale ) && b_something_to_scale ), "Some count per player must be defined to scale spawn manager: " + self.targetname + " at" + self.origin );
	
	if( isdefined( n_count_per_player ) )
	{
		self.count = get_num_scaled_by_player_count( self.count, n_count_per_player );
	}
	if( isdefined( n_active_max_per_player ) )
	{
		self.sm_active_count_max = get_num_scaled_by_player_count( self.sm_active_count_max, n_active_max_per_player );
	}
	if( isdefined( n_active_min_per_player ) )
	{
		self.sm_active_count_min = get_num_scaled_by_player_count( self.sm_active_count_min, n_active_min_per_player );
	}
}

function get_num_scaled_by_player_count( n_base, n_add_per_player )
{
	n_num = n_base - n_add_per_player;
	foreach( e_player in level.players )
	{
		n_num += n_add_per_player;
	}
	return n_num;
}

// Self is array of players
function get_random_player()
{
	e_player = self[ 0 ];
	if( self.size > 1 )
	{
		e_player = self[ RandomInt( self.size ) ];
	}
	return e_player;
}

function get_not_in_laststand()
{
	a_e_players_up = [];
	
	for( i = 0; i < level.players.size; i++ )
	{
		if( !level.players[ i ] laststand::player_is_in_laststand() )
		{
			if ( !isdefined( a_e_players_up ) ) a_e_players_up = []; else if ( !IsArray( a_e_players_up ) ) a_e_players_up = array( a_e_players_up ); a_e_players_up[a_e_players_up.size]=level.players[ i ];;
		}
	}
	
	return a_e_players_up;
}

// Self is trigger
function kill_players( str_notify )
{
	level endon( str_notify );
	while( 1 )
	{
		self waittill( "trigger", e_toucher );
		for( i = 0; i < level.players.size; i++ )
		{
			if( e_toucher == level.players[i] && !e_toucher laststand::player_is_in_laststand() )
			{
				e_toucher DoDamage( e_toucher.health + 100, e_toucher.origin );
			}
		}
		wait 1;
	}
}

// Self is ent
function wait_till_no_players_looking_at()
{
	while( 1 )
	{
		n_look_count = 0;
		
		for( i = 0; i < level.players.size; i++ )
		{
			if( level.players[ i ] util::is_looking_at( self ) )
			{
				n_look_count ++;
			}
		}
		if( n_look_count == 0 )
		{
			return;
		}
		
		wait .25;
	}
}

/***********************************
 * AI
 * ********************************/
 
// Self is AI
function track_player( str_endon, n_radius = 256 )
{
	self endon( "death" );
	if( isdefined( str_endon ) )
	{
		level endon( str_endon );
	}
	
	self.goalradius = n_radius;
	
	while( 1 )
	{
		a_e_players_up = get_not_in_laststand();
		e_prey = a_e_players_up get_random_player();
		
		while( isdefined( e_prey ) && !e_prey laststand::player_is_in_laststand() )
		{
			self SetGoal( e_prey GetOrigin() ); // HACK: SetGoal with player ent doesnt' work
			
			wait RandomFloatRange( 2, 4 );
		}
		
		wait .15;
	}
}

// Spawns ambient guys and vehicles
// Specifics per entity go in spawn function
function ambient_spawns( str_spawners, str_key = "targetname", n_spawners, t_cleanup, str_endon, n_next_wave_timeout )
{	
	level endon( str_endon ); // Comment out to test
	
	a_e_ambients = [];
	a_spawners = GetEntArray( str_spawners, str_key );
	if( !isdefined( n_spawners ) )
	{
		n_spawners = a_spawners.size;
	}
	
	t_cleanup thread ambient_spawns_cleanup( str_endon );
	
	while( 1 )
	{
		a_spawners = array::randomize( a_spawners );
		
		for( i = 0; i < n_spawners; i++ )
		{
			e_ambient = a_spawners[ i ] spawner::spawn();
			
			{wait(.05);};
			
			if( IsAlive( e_ambient ) )
			{
				if( IsAI( e_ambient ) )
				{
					if ( !isdefined( a_e_ambients ) ) a_e_ambients = []; else if ( !IsArray( a_e_ambients ) ) a_e_ambients = array( a_e_ambients ); a_e_ambients[a_e_ambients.size]=e_ambient;;
			
					e_ambient ai::set_ignoreall( true );
					e_ambient.goalradius = 8;
				}
				else if( IsVehicle( e_ambient ) )
				{
					nd_spline = GetVehicleNode( e_ambient.target, "targetname" );
					e_ambient thread vehicle::get_on_and_go_path( nd_spline );
				}
			}
		}
		
		array::wait_till( a_e_ambients, "death", n_next_wave_timeout );
	}
}

// Self is trigger multiple
// Delete when touched
function ambient_spawns_cleanup( str_endon )
{
	level endon( str_endon ); // Comment out to test
	
	while( 1 )
	{
		self waittill( "trigger", e_ambient );
		
		if ( IsDefined( e_ambient ) )
		{
			if( IsAI( e_ambient ) )
			{
				e_ambient Delete();
			}
			else
			{
				e_ambient.delete_on_death = true;           e_ambient notify( "death" );           if( !IsAlive( e_ambient ) )           e_ambient Delete();;
			}
		}
	}
}

// Spawn robots in phalanx formation
// Structs denote start and end points
function spawn_phalanx( str_phalanx , str_formation , n_remaining_to_disperse, b_scatter = false, n_timeout_scatter = 0, str_notify_scatter, b_rush_on_scatter = false, str_rusher_key, str_rusher_value, n_max, n_min )
{	
	v_start = struct::get( str_phalanx + "_start" ).origin;
	v_end = struct::get( str_phalanx + "_end" ).origin;
	
	o_phalanx = new RobotPhalanx();
	[[ o_phalanx ]]->Initialize( str_formation, v_start, v_end, 2 , n_remaining_to_disperse );

	if( isdefined( str_notify_scatter ) )
	{
		level waittill( str_notify_scatter );
	}
	wait n_timeout_scatter;
	
	if( b_scatter && o_phalanx.scattered_ == false )
	{
		o_phalanx robotphalanx::ScatterPhalanx();
	}
	
	if( b_rush_on_scatter )
	{
		while ( isdefined( o_phalanx ) && o_phalanx.scattered_ == false )
		{
			wait .25;
		}
		
		make_rushers( str_rusher_key, str_rusher_value, n_max, n_min );
	}	
}	

// Make robots rushers
function make_rushers( str_key, str_value = "targetname", n_max, n_min )
{
	a_ai_robots = GetEntArray( str_key, str_value );
	a_ai_robots = array::randomize( a_ai_robots );
	n_rushers = a_ai_robots.size;
	
	if( isdefined( n_max ) )
	{
		n_rushers = n_max;
	}
	if( isdefined( n_min ) )
	{
		n_rushers = RandomIntRange( n_min, n_rushers + 1 );
	}
	
	for( i = 0; i < n_rushers; i ++ )
	{
		if( IsAlive( a_ai_robots[ i ] ) )
		{
			a_ai_robots[ i ] ai::set_behavior_attribute( "move_mode", "rusher" );
		}
	}
}

function flag_then_func( str_flag, func )
{
	self flag::wait_till( str_flag );
	
	self thread [[ func ]]();
}

function delete_all_non_hero_ai()
{
	a_friendly = GetAITeamArray( "allies" );
	
	foreach ( ai in a_friendly )
	{
		if ( !IsInArray( level.heroes, ai ) )
		{
			ai Delete();
		}
	}
	
	a_enemy = GetAITeamArray( "axis" );
	
	foreach ( ai in a_enemy )
	{
		ai Delete();
	}
}

/***********************************
 * SCENES
 * ********************************/
 
function wait_till_flag_then_play( str_flag, str_scene, n_delay = 0, n_wait = 0, str_flag_cleanup, str_endon )
{
	if( isdefined( str_endon ) )
	{
		level endon( str_endon );
	}
	
	level flag::wait_till( str_flag );
	wait n_delay;
	level thread scene::play( str_scene, "targetname" );
	if( n_wait > 0 || isdefined( str_flag_cleanup ) )
	{
		if( isdefined( str_flag_cleanup ) )
		{
			level flag::wait_till( str_flag_cleanup );
		}	
		wait n_wait;
		level scene::stop( str_scene, "targetname", true );
	}
}

function play_scene_on_notify( str_scene, str_notify )
{
	Assert( IsDefined( str_scene ), "play_scene_on_notify: str_scene is missing!" );
	Assert( IsDefined( str_notify ), "play_scene_on_notify: str_notify is missing!" );
	
	self waittill( str_notify );
	
	self scene::play( str_scene );
}

function skipto_notetrack_time_in_animation( anim_name, str_scene, str_notetrack )  // self = reference object for scene (ent, level, etc.)
{
	a_notetracks = GetNotetrackTimes( anim_name, str_notetrack );
	
	Assert( a_notetracks.size, "skipto_notetrack_time_in_animation: '" + str_scene + "' anim is missing '" + str_notetrack + "' notetrack!" );
	
	n_time = a_notetracks[ 0 ];  // time percentage from 0 to 1
		
	self thread scene::skipto_end( str_scene, undefined, undefined, n_time );		
}

/***********************************
 * Nodes
 * ********************************/
 
function enable_nodes( str_key, str_val = "targetname", b_enable = true )
{
	a_nodes = GetNodeArray( str_key, str_val );
	foreach( nd_node in a_nodes )
	{
		SetEnableNode( nd_node, b_enable );
	}
}

function link_traversals( str_key, str_val, b_link = true )
{
	a_nd = GetNodeArray( str_key, str_val );
	if( b_link )
	{
		foreach( nd in a_nd )
		{
			LinkTraversal( nd );
		}
	}
	else
	{
		foreach( nd in a_nd )
		{
			UnlinkTraversal( nd );
		}
	}
}

/***********************************
 * WEAPONS
 * ********************************/
 
// Self is a player
function wait_till_weapon_held( w_weapon, str_endon )
{
	self endon( "disconnect" );
	self endon( str_endon );
	
	while( self GetCurrentWeapon() != w_weapon )
	{
		wait .1;
	}
}

// Self is a player
function has_weapon( w_has )
{
	a_w_weapons = self GetWeaponsList();
	
	foreach( w in a_w_weapons )
	{
		if( w == w_has )
		{
			return true;
		}
	}
	return false;
}

function is_using_weapon( str_weapon )  // self = player
{
	return ( self GetCurrentWeapon() == GetWeapon( str_weapon ) );
}

/***********************************
 * HUD
 * ********************************/
 
// Self is a player or an array of players
// TODO: this is temporary until we get the real weapon slot HUD
function hero_slot_activate_tutorial( str_hint, str_weapon )
{
	a_e_players = self;
	if( !IsArray( a_e_players ) )
	{
		a_e_players = Array( a_e_players );
	}
	
	foreach( e_player in a_e_players )
	{
		e_player thread hero_slot_hint_think( str_hint, str_weapon );
	}
}

// Self is a player
function hero_slot_hint_think( str_hint, str_weapon )
{
	self endon( "disconnect" );
	
	w_hero = GetWeapon( str_weapon );
	w_current = self GetCurrentWeapon();
	
	if(  w_current != w_hero )
	{
		hint = self OpenLUIMenu( str_hint );
			
		self wait_till_weapon_held( w_hero, "stop_hero_weapon_hint" );
		self CloseLUIMenu( hint );
	}
}

// Self is a player or an array of players
function hero_slot_hint_stop()
{
	a_e_players = self;
	if( !IsArray( a_e_players ) )
	{
		a_e_players = Array( a_e_players );
	}
	
	foreach( e_player in a_e_players )
	{
		e_player notify( "stop_hero_weapon_hint" );
	}
}

/***********************************
 * DEBUG
 * ********************************/	

/#
// Self is ent
function debug_linked( e )
{
	self endon( "death" );
	e endon( "death" );
	
	while( 1 )
	{
		line( e.origin, self.origin, ( 1, 0, 0 ), .1 );
		debug::drawArrow( self.origin, self.angles );
		wait .05;
	}
}

// Self is ent
function draw_line_to_target( target, n_timer, str_start_tag )
{
	self endon( "death" );
	target endon( "death" );
	
	n_timer = gettime() + ( n_timer * 1000 );
	while( GetTime() < n_timer )
	{
		v_start_point = self.origin;
		if( isdefined( str_start_tag ) )
		{
			v_start_point = self GetTagOrigin( str_start_tag );
		}
		
		line( v_start_point, target.origin, ( 1, 0, 0 ), .1 );
		debug::drawArrow( target.origin, target.angles );
		
		{wait(.05);};
	}
}

function debug_link_probe( e_probe )
{
	level endon( "arena_defend_spawn" );
	while( true )
	{
		line( e_probe.origin, self.origin, ( 1, 0, 0 ), .1 );
		debug::debug_sphere( e_probe.origin, 16, ( 1, 0, 0 ), .5, 1 );
		debug::drawArrow( self.origin, self.angles );
		debug::drawArrow( e_probe.origin, e_probe.angles );
		
		{wait(.05);};
	}
}
#/
	
/***********************************
 * EXPLODERS
 * ********************************/
 
//function vtoL_ride_flak_exploders()
//{
//	exploder::exploder( "exploder_flak_vtol_ride" );
//	
//	level flag::wait_till( "flak_vtol_ride_stop" );
//	
//	exploder::exploder_stop( "exploder_flak_vtol_ride" );
//}

function arena_defend_flak_exploders()
{
	exploder::exploder( "exploder_flak_arena_defend" );
	
	level flag::wait_till( "flak_arena_defend_stop" );
	
	exploder::exploder_stop( "exploder_flak_arena_defend" );
}

function alley_flak_exploder()
{
	exploder::exploder( "exploder_flak_alley" );

	level flag::wait_till( "flak_alley_stop" );
	
	exploder::exploder_stop( "exploder_flak_alley" );	
}

function ambient_walk_fx_exploder( b_on = true )
{
	if( b_on )
	{
		exploder::exploder( "fx_exploder_station_ambient_pre_collapse" );
	}
	else
	{
		exploder::exploder_stop( "fx_exploder_station_ambient_pre_collapse" );
	}
}

function arena_defend_sinkhole_exploders()
{
	exploder::exploder( "fx_exploder_turn_off_collapse" );
	
	level flag::wait_till( "sinkhole_charges_detonated" );
	
	wait 1.5; //slight delay to line up better with sinkhole animation
	
	exploder::exploder_stop( "fx_exploder_turn_off_collapse" );
}

//////////////////////////////////////
//				LIGHTING
//////////////////////////////////////
function set_lighting_state_on_spawn()  // self = player
{
	util::wait_network_frame();
	
	if ( IsDefined( level.lighting_state_ramses ) )
	{
		switch ( level.lighting_state_ramses ) 
		{
			case 0:
				self set_lighting_state_alarm();
				break;
			
			case 1:
				self set_lighting_state_time_shift_1();
				break;
				
			case 2:
				self set_lighting_state_time_shift_2();
				break;
				
			case 3:
				self set_lighting_state_start();
				break;
		}
	}
}

function set_lighting_state_alarm()  // self = level or player
{
	level.lighting_state_ramses = 0;
	
	self util::set_lighting_state( 0 );
	
	level clientfield::set( "turn_on_rotating_fxanim_lights" , 1 );
	
	self set_sun_color( 0 );
	
	a_lighting_ents = GetEntArray( "lgt_tent_probe", "script_noteworthy" );
	
	foreach( ent in a_lighting_ents )
	{
		if( ent.classname == "reflection_probe" )
		{
			ent.origin -= (0,0,5000); //TODO: look into why this isn't working
		}
		else
		{
			ent Delete();
		}
	}
}

function set_lighting_state_time_shift_1()  // self = level or player
{
	level.lighting_state_ramses = 1;
	
	self util::set_lighting_state( 0 );  // reuse skybox - this is old Lighting State 2 (Radiant: 1-4, script: 0-3)
	
	self set_sun_color( 1 );
}

function set_lighting_state_time_shift_2()  // self = level or player
{
	level.lighting_state_ramses = 2;
	
	self util::set_lighting_state( 2 );
	
	self set_sun_color( 0 );	
}

function set_lighting_state_start()  // self = level or player
{
	level.lighting_state_ramses = 3;
	
	self util::set_lighting_state( 3 );
	
	self set_sun_color( 0 );
}

function set_sun_color( n_value )  // self = level or player
{
	if ( self == level )
	{
		foreach ( player in level.players )
		{
			player set_sun_color( n_value );
		}
	}
	else if ( IsPlayer( self ) )
	{
		self clientfield::set_to_player( "ramses_sun_color", n_value );
	}
	else 
	{
		AssertMsg( "set_sun_color can only be called on level or players" );
	}	
}

function light_shift_think( str_trigger_targetname, str_level_endon, func_on_trigger )  // self = level
{
	Assert( IsDefined( str_trigger_targetname ), "light_shift_think: str_trigger_targetname is a required input!" );
	Assert( IsDefined( str_level_endon ), "light_shift_think: str_level_endon is a required input!" );
	Assert( IsDefined( func_on_trigger ), "light_shift_think: func_on_trigger is a required input!" );
	
	level endon( str_level_endon );
	
	t_light_shift = GetEnt( str_trigger_targetname, "targetname" );
	Assert( IsDefined( t_light_shift ), "light_shift_think: couldn't find trigger with targetname '" + str_trigger_targetname + "'!" );
	
	while ( true )
	{
		t_light_shift waittill( "trigger", e_player );
		
		if ( IsDefined( e_player ) && IsPlayer( e_player ) )
		{
			e_player [[ func_on_trigger ]]();
		}
	}
}

/***********************************
 * PROTOTYPE TURRET - TODO: this is to test out the concept - not a finalized concept or system
 * ********************************/
 
// Self is vehicle
function turret_pickup_think( s_obj )
{	
	self endon( "death" );
	
	waittillframeend;
	
	w_hero = GetWeapon( "lmg_light" );
	t_pickup = Spawn( "trigger_radius", self.origin + ( 0, 0, 24 ), 0, s_obj.radius, 128 );
	t_pickup.targetname = "turret_pickup_trig";
	t_pickup.script_objective = "vtol_ride";

	t_pickup TriggerIgnoreTeam();
	self thread turret_pickup_hint( t_pickup, w_hero );
	
	while( 1 )
	{
		t_pickup waittill( "trigger", e_player );
		
		if( IsAlive( e_player ) )
		{
			if( e_player turret_pickup_button_pressed() && !e_player has_weapon( w_hero ) )
			{
				vh_occupied = e_player GetVehicleOccupied();
				if( isdefined( vh_occupied ) && vh_occupied == self )
				{
					self UseVehicle( e_player, 0 );
				}
				
				e_player GiveWeapon( w_hero );
				e_player SwitchToWeapon( w_hero );
				level notify( "turret_picked_up" );
				break;
			}
		}
	}
	
	self.delete_on_death = true;           self notify( "death" );           if( !IsAlive( self ) )           self Delete();;
	t_pickup Delete();
}


// Self is Vehicle
// TODO: need to be able to check for hero weapon
function turret_pickup_hint( t_pickup, w_hero )
{
	t_pickup endon( "death" );
	
	while( 1 )
	{
		t_pickup waittill( "trigger", e_player );
		
		if( IsAlive( e_player ) && !e_player has_weapon( w_hero ) )
		{	
			hint = e_player OpenLUIMenu( "TurretTakeTutorial" );
				
			while( isdefined( self ) && !e_player laststand::player_is_in_laststand() && !e_player turret_pickup_button_pressed() && e_player IsTouching( t_pickup ) )
			{
				{wait(.05);};
			}
			
			e_player CloseLUIMenu( hint );
		}
	}
}

// Self is a player
function turret_pickup_button_pressed()
{
	return self MeleeButtonPressed();
}

// Self is a player
function turret_exit_button_pressed()
{
	return self UseButtonPressed();
}

// Self is a player
function remove_inventory_turret()
{
	w_hero = GetWeapon( "lmg_light" );
	
	if( self HasWeapon( w_hero ) )
	{
		self TakeWeapon( w_hero ); // TODO: do we need our own weapon? 
	}
}

////////////////////////
// SPAWN FUNCTIONS
////////////////////////


//-- used for staging vignettes/battles where you need the AI to stay alive, before the player
// reaches a certain point.  Then notify/kill the AI's magic bulletshield globally
function magic_bullet_shield_till_notify( str_kill_mbs, b_disable_w_player_shot, str_phalanx_scatter_notify )
{
	self endon( "death" );
	
	util::magic_bullet_shield( self );
	
	if( b_disable_w_player_shot )
	{
		self thread stop_magic_bullet_shield_on_player_damage( str_kill_mbs, str_phalanx_scatter_notify );
	}
	
	util::waittill_any_ents( level, str_kill_mbs, self, str_kill_mbs, self, "ram_kill_mb" );
	
	util::stop_magic_bullet_shield( self );
}

function stop_magic_bullet_shield_on_player_damage( str_kill_mbs, str_phalanx_scatter_notify )
{
	self endon( "ram_kill_mb" ); // Unique string to this function
	self endon( str_kill_mbs );
	level endon( str_kill_mbs );
	
	while( 1 )
	{
		self waittill( "damage", amount, attacker );
		
		if( IsPlayer( attacker ) )
		{
			//-- if you are breaking up a phalanx, then also kill mbs on that entire group
			if( IsDefined( str_phalanx_scatter_notify ) )
			{
				level notify( str_phalanx_scatter_notify );
				wait 0.05; //process the scatter notify seperately
				level notify( str_kill_mbs );
			}
			
			self notify( str_kill_mbs );
		}
	}
}

function staged_battle_outcomes( str_robot_sm, str_human_sm )
{
	level thread complete_staged_fight_become_rusher( str_robot_sm, str_human_sm );
	level thread complete_staged_fight_enlarge_goal_radius( str_robot_sm, str_human_sm );
}

//-- if all of the soft humans are destroyed for this AI, then make the robot a rusher
//-- this is basically controlled by spawn manager vs spawn manager
function complete_staged_fight_become_rusher( str_robot_sm, str_human_sm )
{
	
	//-- wait for all of the humans from this spawn manager to die
	do
	{
		wait 0.5; //don't need to check this every frame
		a_human_ais = spawn_manager::get_ai( str_human_sm );
	}
	while( a_human_ais.size > 0 || spawn_manager::is_enabled( str_human_sm ) );
	
	//-- for any robots left, remove them from their goal volume and make them rushers
	a_robot_ais = spawn_manager::get_ai( str_robot_sm );
	
	foreach( e_robot in a_robot_ais )
	{
		e_robot ClearGoalVolume();
		e_robot ai::set_behavior_attribute( "move_mode", "rusher" );
	}
}

function complete_staged_fight_enlarge_goal_radius( str_robot_sm, str_human_sm )
{
	//-- wait for all of the robots from this spawn manager to die
	do
	{
		wait 0.5; //don't need to check this every frame
		a_robot_ais = spawn_manager::get_ai( str_robot_sm );
	}
	while( a_robot_ais.size > 0 || spawn_manager::is_enabled( str_robot_sm ) );
	
	//-- for any humans left, give them a large goal radius
	a_human_ais = spawn_manager::get_ai( str_human_sm );
	
	foreach( e_human in a_human_ais )
	{
		e_human.goalradius = 1024;
	}
}

function player_walk_speed_adjustment( e_rubber_band_to, str_endon, n_dist_min, n_dist_max, n_speed_scale_min = 0, n_speed_scale_max = 1 )
{
    Assert( IsPlayer( self ), "player_walk_speed_adjustment() must be called on a player" );
    Assert( IsDefined( e_rubber_band_to ), "e_rubber_band_to is a required argument for player_walk_speed_adjustment()" );
    Assert( IsDefined( n_dist_min ), "n_dist_min is a required argument for player_walk_speed_adjustment()" );
    Assert( IsDefined( n_dist_max ), "n_dist_max is a required argument for player_walk_speed_adjustment()" );

    self endon( str_endon );
    self endon( "death" );

    n_dist_min_sq = n_dist_min * n_dist_min;
    n_dist_max_sq = n_dist_max * n_dist_max;
    self.n_speed_scale_min = n_speed_scale_min;
    self.n_speed_scale_max = n_speed_scale_max;
    
    self thread _player_walk_speed_reset( str_endon );

    // scale the player's speed based on the distance between the player and the entity
    while ( true )
    {
        n_dist_sq = Distance2DSquared( self.origin, e_rubber_band_to.origin );
        n_speed_scale = math::linear_map( n_dist_sq, n_dist_min_sq, n_dist_max_sq, self.n_speed_scale_min, self.n_speed_scale_max );
        
        if( Abs( self GetMoveSpeedScale() - n_speed_scale ) > 0.05 )
        {
        	self SetMoveSpeedScale( n_speed_scale );
        }

        wait 0.05;
    }
}

function _player_walk_speed_reset( str_endon )
{	
	level waittill( str_endon );
	
	const n_player_speed_default = 1;
	self SetMoveSpeedScale( n_player_speed_default );
	self.n_speed_scale_min = undefined;
    self.n_speed_scale_max = undefined;
}

////////////////////////
// POST FX - ALL
////////////////////////

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
	
	if( IsDefined( str_movie_name ) )
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

//////////////////////////////////
// STREAMING HINT
/////////////////////////////////

function scene_model_streamer_hint( a_ents )
{
	n_hint_time = 5.0;
	
	foreach( ent in a_ents )
	{
		if( isdefined( ent.model ) )
		{
			StreamerModelHint( ent.model, n_hint_time );
		}
	}
	
	if( isdefined( self.scenes[0]._s.nextscenebundle ) )
	{
		scene::add_scene_func( self.scenes[0]._s.nextscenebundle, &scene_model_streamer_hint, "play" );
	}
}

function force_stream_1stpersonplayer( n_hint_time = 5 )
{

	StreamerModelHint("c_hro_player_male_egypt_viewbody", n_hint_time ); //-- hardcoded male body now until we get hookups from Conserva
	
}

//////////////////////////////////
// CO-OP TELEPORT
/////////////////////////////////

function co_op_teleport_on_igc_end( str_scene, str_teleport_name )
{
	Assert( IsDefined( str_scene ), "str_scene is undefined" );
	Assert( IsDefined( str_teleport_name ), "str_teleport_name is undefined" );
	
	scene::add_scene_func( str_scene, &teleport_co_op_players_on_scene_done, "done" );
	
	// This makes sure co_op_teleport_on_igc_end isn't a blocking call
	level thread wait_for_scene_done( str_scene, str_teleport_name );
}

function teleport_co_op_players_on_scene_done( a_ents )
{
	level notify( self.scriptbundlename + "_done" );
}

function wait_for_scene_done( str_scene, str_teleport_name )
{
	level waittill( str_scene + "_done" );
	
	util::teleport_players_igc( str_teleport_name );		
}
