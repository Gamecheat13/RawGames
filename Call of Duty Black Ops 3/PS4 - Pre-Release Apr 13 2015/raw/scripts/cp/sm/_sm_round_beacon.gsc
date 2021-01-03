#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#using scripts\cp\_scoreevents;
#using scripts\cp\gametypes\_globallogic;
#using scripts\cp\gametypes\_spawnlogic;
#using scripts\cp\gametypes\_spawning;
#using scripts\cp\sm\_sm_ai_manager;
#using scripts\cp\sm\_sm_round_base;
#using scripts\cp\sm\_sm_ui;


    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

                                                                   	       	     	          	      	                                                                                            	                                                           	                                  









	


	



	



	
#precache( "material", "t7_hud_minimap_beacon_key" );
#precache( "material", "t7_hud_minimap_beacon_key" );
#precache( "material", "t7_hud_waypoints_beacon" );
#precache( "material", "t7_hud_waypoints_defend" );
#precache( "material", "t7_hud_waypoints_defend" );

#precache( "string", "SM_ROUND_BEACON_START" );
#precache( "string", "SM_ROUND_BEACON_DONE" );

#precache( "string", "SM_OBJ_BEACON" );
#precache( "objective", "sm_beacon_defend" );
#precache( "objective", "sm_beacon_activate" );
#precache( "string", "SM_OBJ_BEACON_FAIL" );

#precache( "string", "SM_PROMPT_BEACON_ACTIVATING" );

#precache( "triggerstring", "SM_PROMPT_BEACON_USE" );

function autoexec __init__sytem__() {     system::register("sm_beacon",&__init__,undefined,undefined);    }

function __init__()
{
	clientfield::register( "scriptmover", "sm_beacon_power_state", 1, 2, "int" );
	clientfield::register( "scriptmover", "sm_beacon_damage_state", 1, 3, "int" );	
	clientfield::register( "scriptmover", "sm_beacon_hardpoint", 1, 3, "int" );
	
	clientfield::register( "world", "sm_beacon_health", 1, 12, "float" );
	
	level flag::init( "sm_beacon_activated" );
}

#namespace sm_round_beacon;

function main()
{
	return new cSideMissionRoundBeacon();
}

function is_beacon_active()
{
	return level flag::get( "sm_beacon_activated" );
}

function is_beacon()
{
	return ( ( self.classname === "script_model" ) && ( self.targetname === "sm_beacon" ) );
}

function get_health_fraction()
{
	return ( self.fake_health / self.fake_health_max );
}

function get_health_percentage()
{
	return ( self get_health_fraction() * 100 );
}

function set_health( n_amount )
{
	self.fake_health = math::clamp( n_amount, 0, self.fake_health_max );
	
	level clientfield::set( "sm_beacon_health", self sm_round_beacon::get_health_fraction() );
}

function get_health( n_amount )
{
	return self.fake_health;
}

function get_active_beacon()
{
	e_active_beacon = undefined;
	
	foreach ( e_beacon in get_all_beacons() )
	{
		if ( ( isdefined( e_beacon.activated ) && e_beacon.activated ) )
		{
			e_active_beacon = e_beacon;
			break;
		}
	}
	
	return e_active_beacon;
}

function get_all_beacons()
{
	return GetEntArray( "sm_beacon", "targetname" );
}

function get_active_beacon_location()
{
	e_temp = get_active_beacon();
	
	Assert( IsDefined( e_temp.script_noteworthy ), "get_active_beacon_location() can't find script_noteworthy on active beacon at " + e_temp.origin );
	
	return e_temp.script_noteworthy;
}

function beacon_icon_set( str_icon )  // self = gameobject
{
	self gameobjects::set_3d_icon( "friendly", str_icon );
}

function beacon_icon_reset()
{
	self gameobjects::set_3d_icon( "friendly", "t7_hud_waypoints_defend" );
}

function get_active_beacon_gameobject()  
{
	e_beacon = get_active_beacon();
	
	o_gameobject = undefined;
	
	if ( IsDefined( e_beacon ) && ( IsDefined( e_beacon.o_gameobject ) ) )
	{
	    o_gameobject = e_beacon.o_gameobject;
	}
	
	return o_gameobject;
}

function setup_respawn_points( str_team )
{
	// this part is a bit of a hack.  
	// just going to delete all other beacons respawn points. 
	// the spawn system currently is only able to handle entities by targetname
	// as a group.
	a_all_beacons = sm_round_beacon::get_all_beacons();

	foreach ( beacon in a_all_beacons )
	{
		if ( beacon == self )
			continue;
		
		foreach ( spawn in beacon.spawnpoints )
		{
			spawn struct::delete();
		}
	}
	// end hack
	
	spawnlogic::clear_spawn_points();
	spawnlogic::add_spawn_points( str_team, "cp_coop_respawn" );
	spawning::updateAllSpawnPoints();
}

function activate_beacon( str_team )  // self = gameobject
{
	if ( level flag::get( "sm_beacon_activated" ) )
	{
		return;
	}
	
	level flag::set( "sm_beacon_activated" );
	
	cSideMissionRoundBase::objective_complete( self gameobjects::get_objective_ids()[ 1 ] );
	
	cSideMissionRoundBase::play_vo_to_all_players( "vox_beacon_activated" );
	
	self.activated = true;
	
	self gameobjects::allow_use( "none" );
	self gameobjects::set_owner_team( str_team );
	
	self beacon_icon_set( "t7_hud_waypoints_defend" );
	
	v_hud_green = ( 0.53725, 0.80392, 0.28627 );
	self gameobjects::set_objective_color( "enemy", v_hud_green );
	self gameobjects::set_objective_color( "friendly", v_hud_green );
	
	self.visuals[ 0 ] sm_ui::interact_prompt_remove();
	self.visuals[ 0 ] Unlink();
	
	e_beacon = self.visuals[ 0 ];
	e_beacon thread display_beacon_health( self );
	e_beacon clientfield::set( "sm_beacon_power_state", 1 );
	e_beacon.activated = true;
	
	SMAIManager::AIM_SetupBeaconAttackLocations( e_beacon );
	
	// Store the guard nodes around the beacon for AI navigation
	e_beacon.a_nd_attack_locs = GetNodesInRadiusSorted( e_beacon.origin, 384, 0, 128, "Guard" );
	// Automatically tag the near nodes as "melee" types.
	foreach( nd_loc in e_beacon.a_nd_attack_locs )
	{
		if ( Distance2DSquared( e_beacon.origin, nd_loc.origin ) <= 72*72 )
		{
			nd_loc.b_in_beacon_melee_range = true;
		}
	}
	
	// setup spawning on beacon
	if ( IsDefined( e_beacon.spawnpoints ) )
	{
		e_beacon setup_respawn_points( str_team );
	}
	
	cSideMissionRoundBase::set_objective_spawning_at_position( e_beacon.origin );
	
	util::wait_network_frame();  // wait network frame since oed clientfield needs to be updated again
	
	self.visuals[ 0 ] sm_ui::show_model_in_sitrep();
}

function disable_beacon()  // self = gameobject
{
	self.visuals[ 0 ] Unlink();
	
	self gameobjects::allow_use( "none" );
	
	self gameobjects::set_2d_icon( "enemy", undefined );
	self gameobjects::set_3d_icon( "enemy", undefined );
	self gameobjects::set_2d_icon( "friendly", undefined );
	self gameobjects::set_3d_icon( "friendly", undefined );
	
	self gameobjects::release_all_objective_ids();
	
	self.visuals[ 0 ] sm_ui::interact_prompt_remove();
}

function beacon_hardpoint_show()
{
	e_beacon = get_active_beacon();
	
	e_beacon clientfield::set( "sm_beacon_hardpoint", 1 );
}

function beacon_hardpoint_hide()
{
	e_beacon = get_active_beacon();
	
	e_beacon clientfield::set( "sm_beacon_hardpoint", 0 );	
}

function active_beacon_icons_hide()
{
	o_gameobject = get_active_beacon_gameobject();
	
	// minimap icons
	if ( IsDefined( o_gameobject.compassIcons ) )
	{
		o_gameobject.compassIconsHidden = ArrayCopy( o_gameobject.compassIcons );
	}
	
	// waypoints
	if ( IsDefined( o_gameobject.worldIcons ) )
	{
		o_gameobject.worldIconsHidden = ArrayCopy( o_gameobject.worldIcons );
	}
	
	// hide icons
	o_gameobject gameobjects::set_2d_icon( "enemy", undefined );
	o_gameobject gameobjects::set_3d_icon( "enemy", undefined );
	o_gameobject gameobjects::set_2d_icon( "friendly", undefined );
	o_gameobject gameobjects::set_3d_icon( "friendly", undefined );	
}

function active_beacon_icons_show()
{
	o_gameobject = get_active_beacon_gameobject();
	
	// minimap icons
	if ( IsDefined( o_gameobject.compassIconsHidden ) )
	{
		if ( IsDefined( o_gameobject.compassIconsHidden[ "friendly" ] ) )
		{
			o_gameobject gameobjects::set_2d_icon( "friendly", o_gameobject.compassIconsHidden[ "friendly" ] );
		}
		
		if ( IsDefined( o_gameobject.compassIconsHidden[ "enemy" ] ) )
		{
			o_gameobject gameobjects::set_2d_icon( "enemy", o_gameobject.compassIconsHidden[ "enemy" ] );
		}
	}
	
	// waypoints
	if ( IsDefined( o_gameobject.worldIconsHidden ) )
	{
		if ( IsDefined( o_gameobject.worldIconsHidden[ "friendly" ] ) )
		{
			o_gameobject gameobjects::set_3d_icon( "friendly", o_gameobject.worldIconsHidden[ "friendly" ] );
		}
		
		if ( IsDefined( o_gameobject.worldIconsHidden[ "enemy" ] ) )
		{
			o_gameobject gameobjects::set_3d_icon( "enemy", o_gameobject.worldIconsHidden[ "enemy" ] );
		}
	}	
	
	// clear temp variables
	o_gameobject.compassIconsHidden = undefined;
	o_gameobject.worldIconsHidden = undefined;
}

function display_beacon_health( o_gameobject )  // self = model
{
	level clientfield::set( "sm_beacon_health", 1 );
	
	// Note: script_models get their health decremented even from friendly fire; use fake_health instead so we can tune independently
	self.fake_health_max = 20000;
	self.fake_health = self.fake_health_max;
	
	self SetCanDamage( true );
	b_is_low_health = false;
	n_time_last_vo_notification = 0;
	n_time_last_damaged = 0;
	
	while ( self.fake_health > 0 )
	{
		n_health_fraction = self sm_round_beacon::get_health_fraction();
		
		self show_beacon_damage_state_fx( n_health_fraction );
		
		self waittill( "damage", n_amount, e_attacker );
		self playsound ("evt_beacon_damage");
		
		//	Keep the beacon's real health up so it can't die (until we want it to).
		self.health = 20000;
		
		/#  // Don't do damage to beacon if dvar is set
			if ( GetDvarInt( "sidemission_beacon_damage_immune" ) > 0 )
			{
				continue;
			}
		#/
		
		if ( IsDefined( e_attacker ) && !o_gameobject gameobjects::is_friendly_team( e_attacker.team ) )
		{
			level notify( "sm_beacon_damaged", n_amount, e_attacker );
			self sm_round_beacon::set_health( self.fake_health - n_amount );
			
			n_time_last_damaged = GetTime();
		}
		
		b_should_play_damage_vo = ( ( n_time_last_damaged - n_time_last_vo_notification ) > ( 8 * 1000 ) );
		
		if ( b_should_play_damage_vo )
		{
			cSideMissionRoundBase::play_vo_to_all_players( "vox_beacon_attack" );
			
			n_time_last_vo_notification = GetTime();
		}
		
		if ( !b_is_low_health && ( n_health_fraction < 0.25 ) )
		{
			cSideMissionRoundBase::play_vo_to_all_players( "vox_beacon_damaged" );
			self clientfield::set( "sm_beacon_power_state", 2 );
			o_gameobject show_low_health_minimap_icon();
			b_is_low_health = true;
		}
	}
	
	self.health = 0;	// So AI stop shooting it
	
	level clientfield::set( "sm_beacon_health", 0 );
	
	self clientfield::set( "sm_beacon_damage_state", 4 );
	self clientfield::set( "sm_beacon_power_state", 0 );
	
	self Ghost();  // TODO: get destroyed model and swap here
	
	o_gameobject sm_round_beacon::disable_beacon();
	
	wait 3;
	
	cSideMissionRoundBase::play_vo_to_all_players( "vox_beacon_destroyed" );
	
	globallogic::endGame( level.enemy_ai_team, &"SM_OBJ_BEACON_FAIL" );
	//sm_ui::mission_failed( &"SM_OBJ_BEACON_FAIL" );
}

function show_beacon_damage_state_fx( n_health_fraction )  // self = model
{
	if ( n_health_fraction > 0.75 )
	{
		self clientfield::set( "sm_beacon_damage_state", 0 );
	}
	else if ( ( n_health_fraction > 0.50 ) && ( n_health_fraction < 0.75 ) )
	{
		// damage state 1
		self clientfield::set( "sm_beacon_damage_state", 1 );
	}
	else if ( ( n_health_fraction > 0.15 ) && ( n_health_fraction < 0.50 ) )
	{
		// damage state 2
		self clientfield::set( "sm_beacon_damage_state", 2 );
	}
	else if ( n_health_fraction < 0.15 )
	{
		// damage state 3
		self clientfield::set( "sm_beacon_damage_state", 3 );
	}
}

function show_low_health_minimap_icon()
{
	// set icons
	self gameobjects::set_2d_icon( "enemy", "t7_hud_minimap_beacon_key" );
	self gameobjects::set_3d_icon( "enemy", "t7_hud_waypoints_defend" );
	self gameobjects::set_2d_icon( "friendly", "t7_hud_minimap_beacon_key" );
	self gameobjects::set_3d_icon( "friendly", "t7_hud_waypoints_defend" );
	
	// set color
	v_hud_red = ( 0.92549, 0.10980, 0.14118 );
	self gameobjects::set_objective_color( "enemy", v_hud_red );
	self gameobjects::set_objective_color( "friendly", v_hud_red );
}

class cSideMissionRoundBeacon : cSideMissionRoundBase
{
	var m_a_beacon_gameobjects;
	var m_obj_defend;
	
	constructor()
	{
		m_str_round_start = &"SM_ROUND_BEACON_START";
		m_str_round_complete = &"";			// Show nothing at end of round.
		m_b_show_countdown = false;
		m_func_start = &start_vo;
		
		a_beacon_structs = struct::get_array( "sm_beacon", "targetname" );
		
		Assert( ( a_beacon_structs.size > 0 ), "cSideMissionRoundBeacon: could not find any structs for beacons!" );
		
		m_a_beacon_gameobjects = [];
		foreach ( s_beacon in a_beacon_structs )
		{
			s_gameobject = setup_beacon_gameobject( s_beacon );
			
			array::add( m_a_beacon_gameobjects, s_gameobject );
		}
		
		respawnPoints = spawnlogic::get_spawnpoint_array( "cp_coop_respawn" );
		a_all_beacons = sm_round_beacon::get_all_beacons();
	
		// associate each respawn point with one beacon based on distance
		foreach( spawn in respawnPoints )
		{
			closest_beacon = undefined;
			closest_distance = 999999999;
	
			foreach( beacon in a_all_beacons )
			{
				if ( DistanceSquared( spawn.origin, beacon.origin ) < closest_distance )
				{
					closest_distance = DistanceSquared( spawn.origin, beacon.origin );
					closest_beacon = beacon;
				}
			}	
			
			// if this hits likely there are no beacons in the level
			if ( !IsDefined( closest_beacon ) )
				continue;
			
			if ( !IsDefined( closest_beacon.spawnpoints ) )
			{
				closest_beacon.spawnpoints = [];
			}
			
			closest_beacon.spawnpoints[closest_beacon.spawnpoints.size] = spawn;
		}
	}
	
	destructor()
	{
		
	}
	
	function main()
	{		
		level flag::wait_till( "sm_beacon_activated" );
		
		// disable all other beacons
		foreach ( o_gameobject in m_a_beacon_gameobjects )
		{
			if ( !( isdefined( o_gameobject.activated ) && o_gameobject.activated ) )
			{
				o_gameobject sm_round_beacon::disable_beacon();
			}
		}
		
		m_obj_defend = objective_add_to_pause_menu( &"sm_beacon_defend", o_gameobject.visuals[ 0 ] );
	}
	
	function on_end_game( success )
	{
		if ( success && IsDefined( m_obj_defend ) )
		{
			objective_complete( m_obj_defend );
		}
	}

	function start_vo()
	{
		play_vo_to_all_players( "vox_activate_beacon" );
	}
	
	function setup_beacon_gameobject( s_beacon )
	{
		const MODEL_HEIGHT = 200;
		const TRIGGER_OFFSET_FROM_GROUND = 55;
		
		const TRIGGER_SPAWN_FLAGS = 0;
		const TRIGGER_RADIUS = 100;
		
		TRIGGER_HEIGHT = ( MODEL_HEIGHT - TRIGGER_OFFSET_FROM_GROUND );
		
		if(!isdefined(s_beacon.angles))s_beacon.angles=( 0, 0, 0 );
		
		v_offset = ( 0, 0, TRIGGER_OFFSET_FROM_GROUND );
		
		trigger = Spawn( "trigger_radius_use", s_beacon.origin + v_offset, TRIGGER_SPAWN_FLAGS, TRIGGER_RADIUS, TRIGGER_HEIGHT );	
		trigger.angles = s_beacon.angles;
		
		trigger SetCursorHint( "HINT_INTERACTIVE_PROMPT" );
		trigger SetHintString( &"SM_PROMPT_BEACON_USE" );
		trigger TriggerIgnoreTeam();
		trigger UseTriggerRequireLookAt();
		
		// You can add multiple models into the gameobjects model array, each with their own relative offset
		gobj_model_offset = ( 0, 0, 35 );
		gobj_visuals[0] = util::spawn_model( "p7_int_beacon_spire", s_beacon.origin, s_beacon.angles );
		gobj_visuals[0].targetname = "sm_beacon";
		gobj_visuals[0].activated = false;
		gobj_visuals[0] sm_ui::interact_prompt_set( 1 );
		gobj_visuals[0] linkto( trigger );
		
		// script_noteworthy KVP can be used as a location identifier on beacon
		if ( IsDefined( s_beacon.script_noteworthy ) )
		{
			gobj_visuals[0].script_noteworthy = s_beacon.script_noteworthy;
		}
		
		gobj_visuals[0] DisconnectPaths();
		
		// Create the gameobject
		gobj_team = "allies";
		gobj_trigger = trigger;
		gobj_objective_name = &"sm_beacon_activate";
		gobj_offset = ( 0, 0, MODEL_HEIGHT - TRIGGER_OFFSET_FROM_GROUND );  // offset icon to top of model
		s_gameobject = gameobjects::create_use_object( gobj_team, gobj_trigger, gobj_visuals, gobj_offset, gobj_objective_name );
	
		// Setup gameobject params
		s_gameobject gameobjects::allow_use( "friendly" );
		s_gameobject gameobjects::set_use_time( 3 );	// How long the progress bar takes to complete
		s_gameobject gameobjects::set_use_text( &"SM_PROMPT_BEACON_ACTIVATING" );
		//s_gameobject gameobjects::set_use_hint_text( &"SM_PROMPT_BEACON_USE" );
		s_gameobject gameobjects::set_visible_team( "friendly" );				// How can see the gameobject
	
		// Setup gameobject callbacks
		s_gameobject.onUse = &onUse;
		s_gameobject.onBeginUse = &onBeginUse;
		s_gameobject.onUseUpdate = &onUseUpdate;
		s_gameobject.onCantUse = &onCantUse;
		s_gameobject.onEndUse = &onEndUse;		
		
		// set up icons
		s_gameobject gameobjects::set_2d_icon( "enemy", "t7_hud_minimap_beacon_key" );
		s_gameobject gameobjects::set_3d_icon( "enemy", "t7_hud_waypoints_beacon" );
		s_gameobject gameobjects::set_2d_icon( "friendly", "t7_hud_minimap_beacon_key" );
		s_gameobject gameobjects::set_3d_icon( "friendly", "t7_hud_waypoints_beacon" );	
		
		s_gameobject gameobjects::set_objective_entity( gobj_visuals[ 0 ] );
		
		s_gameobject.activated = false;  // used by this round objective only
		
		gobj_visuals[0].o_gameobject = s_gameobject;  // store gameobject on model since model is easily accessible globally
		
		return s_gameobject;
	}
	
	// Called when gameobject has been "used"
	function onUse( player )  // self = gameobject
	{
		self sm_round_beacon::activate_beacon( player.team );
	}
	
	// Called when the Use Functionality Starts
	function onBeginUse( player )  // self = gameobject
	{
	
	}
	
	// When Using gameobject
	function onUseUpdate( team, progress, change )  // self = gameobject
	{
		
	}
	
	// Called when the Use Functionality Ends
	function onEndUse( team, player, success )  // self = gameobject
	{
		if ( !self.activated )
		{
			self gameobjects::allow_use( "friendly" );
		}
	}
	
	// Called when not able to use
	function onCantUse( player )  // self = gameobject
	{
		
	}	
	
	function dev_clean_up_round()
	{
		// activate a random beacon so round progresses
		a_beacons = sm_round_beacon::get_all_beacons();
		
		m_beacon = array::random( a_beacons );
		
		m_beacon.o_gameobject sm_round_beacon::activate_beacon( level.players[0].team );
	}
}

