#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\_specialops;

#include maps\_util_carlos;
#include maps\_hud_util;

main()
{
	spec_ops_map_prep();
	
	template_so_level( "london" );
	
	set_custom_gameskill_func( maps\_gameskill::solo_player_in_coop_gameskill_settings );
	
	// Precache
	PrecacheString( &"SO_TIMETRIAL_LONDON_HINT_SWITCH" );
	PrecacheString( &"SO_TIMETRIAL_LONDON_ALLEY" );
	PrecacheString( &"SO_TIMETRIAL_LONDON_WAREHOUSE_ENTRANCE" );
	PrecacheString( &"SO_TIMETRIAL_LONDON_WAREHOUSE_INTERIOR" );
	PrecacheString( &"SO_TIMETRIAL_LONDON_WAREHOUSE_WINDOWS" );
	PrecacheString( &"SO_TIMETRIAL_LONDON_DOCK_YARD" );
	PrecacheString( &"SO_TIMETRIAL_LONDON_DOCK_GATE" );
	PrecacheString( &"SO_TIMETRIAL_LONDON_PARKWAY" );
	PrecacheString( &"SO_TIMETRIAL_LONDON_CONSTRUCTION_SITE" );
	PrecacheString( &"SO_TIMETRIAL_LONDON_OBJ_1" );
	PrecacheString( &"SO_TIMETRIAL_LONDON_OBJ_2" );
	PrecacheString( &"PLATFORM_HOLD_TO_USE" );
	PrecacheString( &"SO_TIMETRIAL_LONDON_ACCESSING" );
    PrecacheString( &"SO_TIMETRIAL_LONDON_TRANSFERRING" );
	
	turret_loc_table = [];
	turret_loc_table[ "SO_TIMETRIAL_LONDON_ALLEY" ]					= &"SO_TIMETRIAL_LONDON_ALLEY";
	turret_loc_table[ "SO_TIMETRIAL_LONDON_WAREHOUSE_ENTRANCE" ]	= &"SO_TIMETRIAL_LONDON_WAREHOUSE_ENTRANCE";
	turret_loc_table[ "SO_TIMETRIAL_LONDON_WAREHOUSE_INTERIOR" ]	= &"SO_TIMETRIAL_LONDON_WAREHOUSE_INTERIOR";
	turret_loc_table[ "SO_TIMETRIAL_LONDON_WAREHOUSE_WINDOWS" ]		= &"SO_TIMETRIAL_LONDON_WAREHOUSE_WINDOWS";
	turret_loc_table[ "SO_TIMETRIAL_LONDON_DOCK_YARD" ]				= &"SO_TIMETRIAL_LONDON_DOCK_YARD";
	turret_loc_table[ "SO_TIMETRIAL_LONDON_DOCK_GATE" ]				= &"SO_TIMETRIAL_LONDON_DOCK_GATE";
	turret_loc_table[ "SO_TIMETRIAL_LONDON_PARKWAY" ]				= &"SO_TIMETRIAL_LONDON_PARKWAY";
	turret_loc_table[ "SO_TIMETRIAL_LONDON_CONSTRUCTION_SITE" ]		= &"SO_TIMETRIAL_LONDON_CONSTRUCTION_SITE";
	maps\_remoteturret::precache_cam_names( turret_loc_table );
	
	maps\so_timetrial_london_precache::main();
	maps\london_precache::main();
	
	// Starts
	default_start( ::start_intro );
	add_start( "start_intro",		::start_intro );

	// Fx / Art Init
	maps\so_timetrial_london_fx::main();
	maps\london_fx::main();
	maps\westminster_tunnels_fx::main();
	maps\createart\london_art::main();
	maps\_compass::setupMiniMap( "compass_map_london_start", "start_minimap_corner" );
	
	maps\_load::main();
	
	// Needed for night vision setup
	init_player_roles();
	
	players = [ level.ground_player ];
	maps\_nightvision::main( players, 2 );
	maps\_remoteturret::init();
	maps\_patrol_anims::main();
	maps\london_docks_anim::main();
	maps\so_timetrial_london_anim::main();
	
	post_load_level_prep();
	
	init_level_flags();
	setup_fx();
	setup_hud();
	setup_gameplay();
}

// -.-.-.-.-.-.-.-.-.-.-.-. Clean Up -.-.-.-.-.-.-.-.-.-.-.-. //

spec_ops_map_prep()
{
	entity_clean_up();
	open_doors();
	disconnect_paths();
}

entity_clean_up()
{	
	so_make_bcslocations_specialops_ent();
	
	so_make_specialops_ent( "trigger_multiple_visionset", "classname", true );
	so_make_specialops_ent( "trigger_multiple_ambient", "classname", true );
	so_make_specialops_ent( "trigger_multiple_slide", "classname" );
	so_make_specialops_ent( "trigger_garage_door", "targetname", false );
	
	so_delete_all_triggers();
	so_delete_all_spawners();
	so_delete_all_by_type( ::type_goalvolume, ::type_infovolume, ::type_weapon_placed, ::type_turret );
	
	ents = getentarray();
	foreach ( e in ents )
	{
		if ( !isdefined( e.classname ) )
			continue;
		
		if ( isSubStr( e.classname, "actor_" ) )
			e.script_moveoverride = 1;
	}
}

open_doors()
{
	door = GetEnt( "docks_warehouse_door", "targetname" );
	door rotateYaw( 80, 1 );
	door connectPaths();

	padlock = GetEnt( "warehouse_padlock", "targetname" );
	latch = GetEnt( "warehouse_padlock_latch", "targetname" );
	padlock delete();
	
	doors = GetEntArray( "docks_garage_doors", "targetname" );
	array_thread( doors, maps\london_docks_code::garage_door_open );
	
	triggers = GetEntArray( "trigger_garage_door", "targetname" );
	array_thread( triggers, maps\london_docks_code::trigger_garage_door );
	array_thread( triggers, ::activate_trigger );
	
	door = get_target_ent( "docks_gate_door" );
	door connectpaths();
	door delete();
}

disconnect_paths()
{
	array_call( GetEntArray( "disconnect_paths", "targetname" ), ::DisconnectPaths );	
}

post_load_level_prep()
{
	level.struct = undefined;
	level_entity_prep();
}

level_entity_prep()
{
	// spawn and setup the van for road block
	level.docks_vans = spawn_vehicles_from_targetname( "docks_sas_van" );
	foreach ( van in level.docks_vans )
	{
		if ( isdefined( van.script_parameters ) && van.script_parameters == "sas_orange" )
			continue;
		van Vehicle_TurnEngineOff();
		van gopath();
	}
	
	// roll the big pipes
	ents = GetEntArray( "sewer_pipe", "targetname" );
	dozer = GetEnt( "docks_bulldozer", "targetname" );
	ents[ ents.size ] = dozer;

	foreach ( ent in ents )
	{
    	add_cleanup_ent( ent, "docks_stuff" );
		ent.animname = ent.script_noteworthy;
		ent setanimtree();
	}

	node = getstruct( "sewer_pipes_animnode", "targetname" );
	node thread anim_single( ents, "sewer_pipe_roll" );

	blocker = GetEnt( "sewer_pipes_blocker", "targetname" );
	blocker DisconnectPaths();
	
	// rid the forklift and its cargo
	cargo = getent( "forklift_pallet", "targetname" );
	more_cargo = getentarray( cargo.target, "targetname" );
	array_call( more_cargo, ::delete );
	cargo delete();
}

// -.-.-.-.-.-.-.-.-.-.-.-. Preload Setup -.-.-.-.-.-.-.-.-.-.-.-. //

init_player_roles()
{
	AssertEx( IsSplitScreen() || is_coop(), "Time Trial London only playable in co-op." );
	
	level.specops_character_selector = GetDvar( "coop_start" );
	//AssertEx( IsDefined( level.specops_character_selector ) && level.specops_character_selector != "", "Coop player role dvar not set." );
	
	if ( level.specops_character_selector == "so_char_host" )
	{
		level.turret_player 	= level.players[ 0 ];
		level.ground_player	 	= level.players[ 1 ];
	}
	else
	{
		level.turret_player 	= level.players[ 1 ];
		level.ground_player	 	= level.players[ 0 ];
	}
}
// -.-.-.-.-.-.-.-.-.-.-.-. Setup Fx -.-.-.-.-.-.-.-.-.-.-.-. //

setup_fx()
{
	org = get_target_ent( "end_smoke" );
	PlayFX( getfx( "end_smoke" ), org.origin, AnglesToForward( org.angles ) );
}

// -.-.-.-.-.-.-.-.-.-.-.-. HUD Setup -.-.-.-.-.-.-.-.-.-.-.-. //
setup_hud()
{		
	// 	progress bar settings
    level.secondaryProgressBarY = 75;
    level.secondaryProgressBarHeight = 14;
    level.secondaryProgressBarWidth = 152;
    level.secondaryProgressBarTextY = 45;
    level.secondaryProgressBarFontSize = 2;
}

// -.-.-.-.-.-.-.-.-.-.-.-. General Gameplay Setup -.-.-.-.-.-.-.-.-.-.-.-. //

init_level_flags()
{
	flag_init( "so_timetrial_london_start" );
	flag_init( "so_timetrial_london_complete" );
	
	flag_init( "kick_it" );
	
	flag_init( "laptop_0_hacked" );
	flag_init( "laptop_1_hacked" );
	flag_init( "laptop_2_hacked" );
}

setup_gameplay()
{
	add_hint_string( "hint_switch", &"SO_TIMETRIAL_LONDON_HINT_SWITCH", ::should_break_switch_hint );
	setup_difficulty_settings();
	
	init_helicopters();
	add_ai_spawn_logic();
	add_ai_clean_up_logic();
	
	thread enable_challenge_timer( "so_timetrial_london_start", "so_timetrial_london_complete" );
	thread fade_challenge_in( undefined, false );
	thread fade_challenge_out( "so_timetrial_london_complete", true );
	
	// Custom end of game logic
	level.custom_eog_no_defaults			= true;
	level.eog_summary_callback 				= ::custom_eog_summary;
}

// Note: This level no longer uses difficulty settings. Keeping
// this in case we switch back.
setup_difficulty_settings()
{
	switch( level.gameSkill )
	{
		case 0:// easy
		case 1:// regular
			level.challenge_time_limit = 240; //4:00 min
			break;
		case 2:// hardened
			level.challenge_time_limit = 240; //4:00 min
			break;
		case 3:// veteran
			level.challenge_time_limit = 240; //4:00 min
			break;
		default:
			AssertMsg( "Invalid difficulty setting: " + level.gameSkill );
			level.challenge_time_limit = 240; //4:00 min
			break;
	}
}

init_laptop_hack_think()
{
	// Turret player transfer system
	array_thread( getentarray( "remote_turret_transfer", "targetname" ), ::transfer_turret_player );
	
	// Hint system
	array_thread( getentarray( "switch_camera_hint", "targetname" ), ::switch_camera_hint );
}

init_helicopters()
{
	maps\_chopperboss::chopper_boss_locs_populate( "script_noteworthy", "so_chopper_boss_path_struct" );
}

dialogue_think()
{	
	level endon( "missionfailed" );
	
	wait 1.0;
	radio_dialogue( "so_time_lond_bsp_support" );
	
	// First Chopper
	trigger_wait_targetname( "littlebird_trigger_1" );
	radio_dialogue( "so_time_lond_bsp_eyeshigh" );
	
	// Guys exiting warehouse
	trigger_wait_targetname( "trig_warehouse_ai" );
	radio_dialogue( "so_time_lond_bsp_lightemup" );
	
	// Construction Yard Packed
	flag_wait( "laptop_2_hacked" );
	wait 1.0;
	radio_dialogue( "so_time_lond_bsp_fifteentargets" );
	
	// Pair of Choppers
	trigger_wait_targetname( "littlebird_trigger_2" );
	radio_dialogue( "so_time_lond_bsp_construction" );
	
	// Outro
	flag_wait( "so_timetrial_london_complete" );
	wait 1.0;
	radio_dialogue( "so_time_lond_bsp_havepackage" );
}

add_ai_spawn_logic()
{
	add_global_spawn_function( "axis", ::ai_think );
	array_spawn_function_targetname( "so_alley_start_patrol", ::kick_it_off );
	array_spawn_function_noteworthy( "boss_littlebird", ::boss_chopper_think );
	
	array_spawn_function_noteworthy( "littlebird_drop_spawners", ::on_spawn_littlebird_drop_off );
}

add_ai_clean_up_logic()
{
	array_thread( getentarray( "targetname", "script_noteworthy" ), ::cleanup_ai_in_volume );
}

player_ground_seek_enable()
{
	self endon( "death" );
	level.turret_player endon( "death" );
	level endon( "special_op_terminated" );
	
	goal_radius_min = 1200;
	if ( self has_shotgun() )
	{
		goal_radius_min = 250;
	}
	
	goal_radius = self.goalradius;
	
	while ( 1 )
	{
		self SetGoalEntity( level.ground_player );
		goal_radius -= 200;
		
		goal_radius = ter_op( goal_radius < goal_radius_min, goal_radius_min, goal_radius );
		self.goalradius = goal_radius;
		
		wait( RandomFloatRange( 2.0, 4.5 ) );
	}
}

boss_chopper_think()
{
	path_start = self get_target_ent();
	self thread maps\_chopperboss::chopper_boss_behavior_little_bird( path_start );
	self thread maps\_chopperboss::chopper_path_release( "death deathspin" );
	
	music_play( "so_timetrial_london_music_end" );
}

ai_think()
{
	if ( !IsAI( self ) )
	{
		if ( self maps\_vehicle::ishelicopter() )
		{
			self ThermalDrawEnable();
			self waittill( "death" );
			
			// Handle helicopters removing themselves
			if ( IsDefined( self ) )
				self ThermalDrawDisable();
		}
		
		return;
	}
	
	// don't linger at cover when you cant see your enemy
	self.aggressivemode = true;

	if ( IsDefined( self.script_patroller ) && IsDefined( self.target ) )
	{
		self maps\_patrol::patrol();
		return;
	}
		
	self endon( "death" );
	if ( IsDefined( self.target ) )
	{
		self.goalradius = 128;
		self.goalheight = 32;
		node = get_target_ent( self.target );
		self follow_path_waitforplayer( node, 0 );
		node = node get_last_ent_in_chain( "struct" );
		if ( IsDefined( node.radius ) )
			self.goalradius = node.radius;
		else
			self.goalradius = 5000;
	}
	wait( RandomFloatRange( 3.0, 5.0 ) );
	self thread player_ground_seek_enable();
}

on_spawn_littlebird_drop_off()
{
	// The drop off littlebirds are not included in the above "axis" global
	// spawn function so force the ai_think() call on them
	self thread ai_think();
	
	// In order for the hit indicator to work the attackee
	// must have a team
	if ( IsDefined( self.script_team ) )
		self.team = self.script_team;
	
	// The _chopperboss() logic already gives the boss chopper a hit
	// indicator, give these drop off choppers one too
	self thread add_damagefeedback();
}

// -.-.-.-.-.-.-.-.-.-.-.-. Starts -.-.-.-.-.-.-.-.-.-.-.-. //

start_intro()
{
	flag_clear( "laststand_on" );
	thread put_player_on_turrets();
	
	array_spawn_targetname( "so_alley_start_patrol" );
	
	thread init_laptop_hack_think();
	thread dialogue_think();
	thread objectives();
	thread start_the_party();
	thread blockers_think();
	thread terminal_0_think();
	thread terminal_1_think();
	thread terminal_2_think();
}

put_player_on_turrets()
{
	setup_turrets();
	
	
	level.ground_player maps\_coop::FriendlyHudIcon_Disable();
	
	flag_clear( "_remoteturret_manual_getoff" );
	
	ent = get_target_ent( "turret_gunner_position" );
	level.turret_player visionsetthermalforplayer( "uav_flir_thermal", 0.25 );
	level.turret_player SetOrigin( ent.origin );
  		
	terminal = getent( "terminal_1", "script_noteworthy" );
	terminal.trigger notify( "trigger", level.turret_player );
	level.turret_player.terminal = terminal;
	level.turret_player Hide();
	level.turret_player.ignoreme = true;
	level.turret_player EnableInvulnerability();
	level.turret_player thread turret_kick_it();
}

setup_turrets()
{
	turret_array = GetEntArray( "sentry", "script_noteworthy" );
	
	foreach ( turret in turret_array )
	{
		if ( !IsDefined( turret.script_parameters ) )
			continue;
		
		param_array = StrTok( turret.script_parameters, ";" );
		
		turret setup_turret_params( param_array );
	}
}

setup_turret_params( param_array )
{
	foreach ( param in param_array )
	{
		if ( param == "removebase" )
		{
			self HidePart( "tag_origin" );
		}
		else if ( IsSubStr( param, "_" ) )
		{
			sub_param_array = StrTok( param, "_" );
			if ( sub_param_array.size != 2 )
			{
				AssertMsg( "Turret sub script param had more then 1 underscore. This isn't handled." );
				continue;
			}
			
			// The arc fields are set directly on the turret as they are ready in
			// _remoteturret to set the player view bounds. The arc functions are
			// called on the turrets to actually set the arc limits of the turret
			switch ( sub_param_array[ 0 ] )
			{
				case "bottomarc":
					self.bottomarc = int( sub_param_array[ 1 ] );
					self SetBottomArc( self.bottomarc );
					break;
				case "toparc":
					self.toparc = int( sub_param_array[ 1 ] );
					self SetTopArc( self.toparc );
					break;
				case "leftarc":
					self.leftarc = int( sub_param_array[ 1 ] );
					self SetLeftArc( self.leftarc );
					break;
				case "rightarc":
					self.rightarc = int( sub_param_array[ 1 ] );
					self SetRightArc( self.rightarc );
					break;
				default:
					AssertMsg( "Sub script param not handled in turret setup: " + sub_param_array[ 0 ] );
					break;
			}
		}
	}
}

objectives()
{
	objective_add( obj( "extract" ), 	"active", 		&"SO_TIMETRIAL_LONDON_OBJ_1" );
	objective_add( obj( "hack" ), 		"current",	 	&"SO_TIMETRIAL_LONDON_OBJ_2" );
	
	breadcrumb( "breadcrumb_alley", "hack" );
	
	laptop = getent( "laptop_0", "script_noteworthy" );
	objective_position( obj( "hack" ), laptop.origin );
	
	flag_wait( "laptop_0_hacked" );
	
	breadcrumb( "breadcrumb_warehouse", "hack" );
	
	laptop = getent( "laptop_1", "script_noteworthy" );
	objective_position( obj( "hack" ), laptop.origin );

	flag_wait( "laptop_1_hacked" );
	
	breadcrumb( "breadcrumb_docks", "hack" );
	
	laptop = getent( "laptop_2", "script_noteworthy" );
	objective_position( obj( "hack" ), laptop.origin );
	
	flag_wait( "laptop_2_hacked" );
	
	objective_state( obj( "hack" ), "done" );
	objective_state( obj( "extract" ), "current" );
	
	org = get_target_ent( "end_smoke" );
	objective_position( obj( "extract" ), org.origin );
	
	flag_wait( "so_timetrial_london_complete" );
	
	objective_complete( obj( "extract" ) );
}

breadcrumb( targetname, objective )
{
	trigger = get_target_ent( targetname );
	while( isdefined( trigger ) )
	{
		objective_position( obj( objective ), trigger.origin );
		trigger waittill( "trigger" );
		if ( !isdefined( trigger.target ) )
			break;
		trigger = trigger get_target_ent();
	}
}

start_the_party()
{
	battlechatter_off( "axis" );
	flag_wait( "kick_it" );
	flag_set( "so_timetrial_london_start" );
	battlechatter_on( "axis" );
	
	ai_array = getaiarray( "axis" );
	
	foreach( ai in ai_array )
	{
		ai GetEnemyInfo( level.ground_player );
		ai thread player_ground_seek_enable();
	}

	ent_array = getentarray();
	foreach ( ent in ent_array )
	{
		if ( isSpawner( ent ) )
		{
			ent.script_patroller = undefined;
		}
	}
	
	triggers = getentarray( "alley_trigger", "script_noteworthy" );
	array_thread( triggers, ::activate_trigger );
	
	music_play( "so_timetrial_london_music_start" );
}

// Each time a computer is hacked a new blocker is opened
blockers_think()
{
	i = 0;
	while ( 1 )
	{
		level waittill( "computer_hacked" );
		
		i++;
		switch ( i )
		{
			case 1:
				thread blocker_open_door();
				break;
			case 2:
				thread blocker_open_windows();
				break;
			case 3:
				thread blocker_open_gate();
				break;
			default:
				AssertMsg( "Invalid number of hacked computers: " + i );
				break;
		}
		
		if ( i >= 3 )
		{
			return;
		}
	}
}

blocker_open_door()
{
	door = GetEnt( "warehouse_door", "targetname" );
	handle = getentarray( door.target, "targetname" );
	foreach ( h in handle )
		h linkTo( door );
	latch2 = GetEnt( "warehouse_padlock_latch2", "targetname" );
	latch2 LinkTo( door );

	door rotateYaw( 145, 1, 0.5 );
	door connectPaths();
}

blocker_open_windows()
{
	for ( i = 1; i < 3; i++ )
	{
		windows = GetEntArray( "blocker_window0" + i, "targetname" );
		
		foreach ( window in windows )
		{
			window delayThread( 0.5*(i-1), ::blocker_slide, (0,0,-85), 1.0, 0.4, 0.0 );
		}
	}
}

blocker_slide( offset, time, accel_time, decel_time, connect_paths )
{
	self MoveTo( self.origin + offset, time, accel_time, decel_time );
	wait time;
	self NotSolid();
	
	if ( IsDefined( connect_paths ) && connect_paths )
	{
		self ConnectPaths();
	}
}

blocker_open_gate()
{
	gate_array = [ "blocker_gate_L", "blocker_gate_R" ];
	
	foreach ( gate in gate_array )
	{
		offset = undefined;
		switch ( gate )
		{
			case "blocker_gate_L":
				offset = (-92,0,0);
				break;
			case "blocker_gate_R":
				offset = (92,0,0);
				break;
			default:
				AssertMsg( "Unhandled gate ent name: " + gate );
				offset = (184,0,0);
				break;
		}
		
		gate_ents = GetEntArray( gate, "targetname" );
		foreach ( ent in gate_ents )
		{
			connect_paths = ter_op( IsDefined( self.classname ) && self.classname == "script_brushmodel", true, false );
			ent thread blocker_slide( offset, 2.5, 0.75, 0.0, connect_paths );
		}
		
		// Delay between left and right parts of the gate moving
		wait 0.5;
	}
}

terminal_0_think()
{
	flag_wait( "laptop_0_hacked" );
	
	triggers = getentarray( "warehouse_spawner_trigger", "script_noteworthy" );
	array_thread( triggers, ::activate_trigger );
}

terminal_1_think()
{
	flag_wait( "laptop_1_hacked" );
	
	triggers = getentarray( "trig_spawn_dock_littlebirds", "script_noteworthy" );
	array_thread( triggers, ::activate_trigger );
}

terminal_2_think()
{
	flag_wait( "laptop_2_hacked" );
	
	triggers = getentarray( "trig_spawn_construction_1", "script_noteworthy" );
	array_thread( triggers, ::activate_trigger );
}

transfer_turret_player()
{
	trigger = Spawn( "script_model", self.origin );	
	
	self.trigger = trigger;

    interval = .05;
    timesofar = 0;
    planttime = 2;

	trigger.angles = self.angles;
	trigger setModel( "com_laptop_2_open_obj" );
	trigger makeUsable();
	trigger SetHintString( &"PLATFORM_HOLD_TO_USE" );
	
	while ( true )
    {
        trigger waittill( "trigger", activator );

		assert( activator == level.ground_player );

		activator disableweapons();
        activator freezeControls( true );

		activator playsound( "scn_enter_code_typing" );

        // set hint string on trigger

        trigger trigger_off();
		
        activator startProgressBar( planttime );
		level.turret_player startProgressBar( planttime );
        activator.progresstext settext( &"SO_TIMETRIAL_LONDON_ACCESSING" );
        level.turret_player.progresstext settext( &"SO_TIMETRIAL_LONDON_TRANSFERRING" );

        success = false;

        while ( true )
        {
            if ( !activator useButtonPressed() )
                break;

            timesofar += interval;
            activator setProgressBarProgress( timesofar / planttime );
            level.turret_player setProgressBarProgress( timesofar / planttime );

            if ( timesofar >= planttime )
            {
                success = true;
                break;
            }
            wait interval;
        }

        activator endProgressBar();
        level.turret_player endProgressBar();

        if ( success )
            break;

        // give information that input failed.
        activator stopsounds( "scn_enter_code_typing" );
        trigger trigger_on();
		activator freezeControls( false );
        activator enableweapons();
    }

	activator enableweapons();
	activator freezeControls( false );

    activator stopsounds( "scn_enter_code_typing" );

	
	// Something like: laptop_0_hacked
	flag_comp_hacked = self.script_noteworthy + "_hacked";
	
	AssertEx( flag_exist( flag_comp_hacked ), "The following generated flag does not exist: " + flag_comp_hacked );
	if ( flag_exist( flag_comp_hacked ) )
	{
		flag_set( flag_comp_hacked );
	}

	level notify( "computer_hacked" );
	
	trigger delete();
	terminal = self get_linked_ent();
	level.turret_player maps\_remoteturret::transfer_to_new_terminal( level.turret_player.terminal, terminal );
	level.turret_player.terminal = terminal;
	
	
}

startProgressBar( planttime )
{
    // show hud elements
    self.progresstext = self createSecondaryProgressBarText();
    self.progressbar = self createSecondaryProgressBar(); 
}

setProgressBarProgress( amount )
{
    if ( amount > 1 )
        amount = 1;

    self.progressbar updateBar( amount );
}

endProgressBar()
{
    self notify( "progress_bar_ended" );
    self.progresstext destroyElem();
    self.progressbar destroyElem();
}

// should be moved to _hud.gsc
createSecondaryProgressBar()
{
    bar = self createClientBar( "white", "black", level.secondaryProgressBarWidth, level.secondaryProgressBarHeight );
    bar setPoint( "CENTER", undefined, 0, level.secondaryProgressBarY );
    return bar;
}

// should be moved to _hud.gsc
createSecondaryProgressBarText()
{
    text = self createClientFontString( "default", level.secondaryProgressBarFontSize );
    text setPoint( "CENTER", undefined, 0, level.secondaryProgressBarTextY );
    return text;
}

kick_it_off()
{
	level endon( "kick_it" );
	self waittill_any( "death" , "damage" , "enemy" );	
	flag_set( "kick_it" );
}

turret_kick_it()
{
	level endon( "kick_it" );
	self.terminal._remote_turrets[ self.terminal.lastTurretIndex ] waittill( "create_badplace" );
	flag_set( "kick_it" );
}

cleanup_ai_in_volume()
{
	volume = self get_target_ent();
	self waittill( "trigger" );
	ai = getaiarray( "axis" );
	guys = [];
	foreach ( a in ai )
	{
		if ( a isTouching( volume ) )
		{
			guys[ guys.size ] = a;
		}
	}
	ai_delete_when_out_of_sight( guys, 128 );
}

switch_camera_hint()
{
	turret = self get_target_ent();
	while( 1 )
	{
		self waittill( "trigger" );
		
		level.ideal_turret = turret;
		
		// can't switch to that turret, even if we wanted to
		if ( level.turret_player.terminal != turret.terminal )
		{
			continue;
		}
		
		if ( level.turret_player.terminal maps\_remoteturret::get_active_turret() == turret )
		{
			continue;
		}		
		
		level.turret_player thread display_hint_timeout( "hint_switch", 8 );
		wait 8.0;
	}
}

should_break_switch_hint()
{
	if ( !isdefined( level.ideal_turret ) )
		return true;

	turret = level.turret_player.terminal maps\_remoteturret::get_active_turret();
	
	if ( level.turret_player.terminal != turret.terminal )
		return true;
	
	return ( level.ideal_turret == turret );
}

// -.-.-.-.-.-.-.-.-.-.-.-. Custom End of Game Summary  -.-.-.-.-.-.-.-.-.-.-.-. //

custom_eog_summary()
{	
	// Total Score Calculations
	time_mil	= level.challenge_end_time - level.challenge_start_time;
	time_sec	= time_mil / 1000;
	time_string	= convert_to_time_string( time_sec, true );
	
	score_diff	= level.specops_reward_gameskill * 10000;
	score_max	= score_diff + 9999;
	
	// Score Time
	time_sec_remain = level.challenge_time_limit - ( time_mil / 1000 );
	score_time		= ( time_sec_remain / level.challenge_time_limit ) * 5000;
	score_time		= Int( Min( score_time, 4999 ) );
	// There are less than 100 guys in the map so this
	// cannot go over 5000
	score_kills	= 0;
	foreach ( player in level.players )
	{
		score_kills += player.stats[ "kills" ] * 50;
	}
	score_kills = Int( Min( score_kills, 4999 ) );
	
	score_final = Int( Min( score_diff + score_time + score_kills, score_max ) );
	
	//  This mission is only co-op
	foreach ( player in level.players )
	{
		setdvar( "ui_hide_hint", 1 );
		
		p1_gameskill	= so_get_difficulty_menu_string( player.gameskill );
		p1_kills		= player.stats[ "kills" ];
		p2_gameskill	= so_get_difficulty_menu_string( get_other_player( player ).gameskill );
		p2_kills		= get_other_player( player ).stats[ "kills" ];
		
		if ( IsDefined( level.MissionFailed ) && level.MissionFailed == true )
		{
			player add_custom_eog_summary_line( "",									"@SPECIAL_OPS_PERFORMANCE_YOU",	"@SPECIAL_OPS_PERFORMANCE_PARTNER" );
			player add_custom_eog_summary_line( "@SPECIAL_OPS_UI_DIFFICULTY",		p1_gameskill,					p2_gameskill );
			player add_custom_eog_summary_line( "@SPECIAL_OPS_UI_KILLS",			p1_kills,						p2_kills );
			player add_custom_eog_summary_line( "@SPECIAL_OPS_UI_TIME",		 		time_string,				time_string );
		}
		else
		{
			player add_custom_eog_summary_line( "",									"@SPECIAL_OPS_PERFORMANCE_YOU",	"@SPECIAL_OPS_PERFORMANCE_PARTNER", "@SPECIAL_OPS_UI_SCORE" );
			player add_custom_eog_summary_line( "@SPECIAL_OPS_UI_DIFFICULTY",		p1_gameskill,					p2_gameskill,						score_diff );
			player add_custom_eog_summary_line( "@SPECIAL_OPS_UI_KILLS",			p1_kills,						p2_kills,							score_kills );
			player add_custom_eog_summary_line( "@SPECIAL_OPS_UI_TIME",		 		time_string,					time_string,						score_time );
			player add_custom_eog_summary_line_blank();
			player add_custom_eog_summary_line( "@SPECIAL_OPS_UI_TEAM_SCORE",																			score_final );
			
			// Override each player's time and score
			player override_summary_time( time_mil );
			player override_summary_score( score_final );
		}
	}
}