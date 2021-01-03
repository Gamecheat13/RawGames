/* zm_zod_quest.gsc
 *
 * Purpose : 	Quest declaration and global quest logic for zm_zod.
 *		
 * 
 * Author : 	G Henry Schmitt
 * 
 * Players must
 *   1. collect the key item
 *   2. collect 4 personal items
 *   3. perform 4 rituals
 *	 4. get 4 soul relics
 *   5. take the 4 soul relics to the PaP crafting location and assemble the PaP
 *   6. perform defend ritual at the PaP site
 * 
 */
 
#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

                                                                                                                               
                                                                                                                                                                                                                                                                                                                                                                                                                 	                                                                                                                                                                          	                                                                                         	                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                                                               	                                                                                                                                                                                                                                              	                                                                                                                                           	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   	                                                                                                                       	   	                                                                                                                                                                                                                                                                                                                         	                                                                                                                                                                                                                                      
                                       	             	                  	                  	                  	                  	                  	  	             	                  	                  	                  	                                                                                  	             	                  	                  	                  	                                                               
                                                                                                                                                                                                                                                                                                    	                                                                                     	                                                                                                                                                                                                                                                                                             	                                                                                                                                                                                                                                                                                                                                                                                                   	                                                                                                                                                                                                                                                                                                         	                                                   

#using scripts\zm\_load;
#using scripts\zm\_zm;
#using scripts\zm\_zm_pack_a_punch_util;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\craftables\_zm_craftables;

#using scripts\zm\zm_zod_craftables;
#using scripts\zm\zm_zod_defend_areas;
#using scripts\zm\zm_zod_quest_vo;
#using scripts\zm\zm_zod_util;
//#using scripts\zm\zm_zod_gamemodes;

// quest hud
#precache( "lui_menu", "ZodQuestHUD" );
#precache( "lui_menu_data", "zod_quest_key" );
#precache( "lui_menu_data", "zod_quest_boxer_memento" );
#precache( "lui_menu_data", "zod_quest_detective_memento" );
#precache( "lui_menu_data", "zod_quest_femme_memento" );
#precache( "lui_menu_data", "zod_quest_magician_memento" );
#precache( "lui_menu", "ZodQuestRelicsHUD" );
#precache( "lui_menu_data", "zod_quest_boxer_relic" );
#precache( "lui_menu_data", "zod_quest_detective_relic" );
#precache( "lui_menu_data", "zod_quest_femme_relic" );
#precache( "lui_menu_data", "zod_quest_magician_relic" );
#precache( "lui_menu", "ZodQuestCarryHUD" );
#precache( "lui_menu_data", "zod_quest_boxer_carry" );
#precache( "lui_menu_data", "zod_quest_detective_carry" );
#precache( "lui_menu_data", "zod_quest_femme_carry" );
#precache( "lui_menu_data", "zod_quest_magician_carry" );

// ritual defends
#precache( "lui_menu", "ZodRitualProgress" );
#precache( "lui_menu_data", "frac" );
#precache( "lui_menu", "ZodRitualReturn" );
#precache( "lui_menu", "ZodRitualSucceeded" );
#precache( "lui_menu", "ZodRitualFailed" );

#precache( "triggerstring", "ZM_ZOD_QUEST_RITUAL_PICKUP_QUEST_KEY" );
#precache( "string", "P1" );
#precache( "string", "P2" );
#precache( "string", "P3" );
#precache( "string", "P4" );

#namespace zm_zod_quest;



function autoexec __init__sytem__() {     system::register("zm_zod_quest",&__init__,undefined,undefined);    }

function __init__()
{	
	callback::on_connect( &on_player_connect );
	// register randomized-locations for objects so host migration doesn't affect it
	// ritual states
	clientfield::register( "world", "quest_key",					1,	1,								"int" );
	clientfield::register( "world", "ritual_progress",				1,	7,	"float" );
	clientfield::register( "world", "ritual_current",				1,	3,			"int" );
	clientfield::register( "world", "ritual_state_boxer",			1,	2,			"int" );
	clientfield::register( "world", "ritual_state_detective",		1, 	2,			"int" );
	clientfield::register( "world", "ritual_state_femme",			1, 	2,			"int" );
	clientfield::register( "world", "ritual_state_magician",		1, 	2,			"int" );
	clientfield::register( "world", "ritual_state_pap",				1, 	2,			"int" );
	clientfield::register( "world", "junction_crane_state",			1,	1,								"int" ); // trigger the crane in the junction to animate

	// hide stuff at start
	a_str_names = array( "boxer", "detective", "femme", "magician" );
	foreach( str_name in a_str_names )
	{
		// ghost the placed relic models
		relic_placed = GetEnt( "quest_ritual_relic_" + str_name + "_placed", "targetname" );
		relic_placed Ghost();

		// turn off corresponding ritual barrier
		a_e_clip = GetEntArray( "ritual_clip_" + str_name, "targetname" );
		foreach( e_clip in a_e_clip )
		{
			e_clip SetInvisibleToAll();
		}
	}
	// also PaP ritual barrier
	a_e_clip = GetEntArray( "ritual_clip_pap", "targetname" );
	foreach( e_clip in a_e_clip )
	{
		e_clip SetInvisibleToAll();
	}

	// ritual timing	
	level.zod_n_rituals_completed = 0;
	
	level.zod_ritual_durations = [];
	level.zod_ritual_durations[ 0 ] = 20;
	level.zod_ritual_durations[ 1 ] = 25;
	level.zod_ritual_durations[ 2 ] = 30;
	level.zod_ritual_durations[ 3 ] = 30;
	level.zod_ritual_durations[ 4 ] = 30;

	// the gatestone
	level.gatestone = SpawnStruct();
	level.gatestone.n_power_level = 0;

	// quest main loop flags
	flag::init("quest_key_found"); // redemption's key
	flag::init("key_boxer_found");
	flag::init("key_detective_found");
	flag::init("key_femme_found");
	flag::init("key_magician_found");
	flag::init("ritual_boxer_ready");
	flag::init("ritual_boxer_complete");
	flag::init("ritual_detective_ready");
	flag::init("ritual_detective_complete");
	flag::init("ritual_femme_ready");
	flag::init("ritual_femme_complete");
	flag::init("ritual_magician_ready");
	flag::init("ritual_magician_complete");
	flag::init("pap_door_open"); // plays when the door to the PaP chamber explodes (4 players are within the trigger, after the 4 rituals have all been completed)
	
	// flags for each gateworm basin in the PaP Chamber	
	flag::init("pap_basin_1");
	flag::init("pap_basin_2");
	flag::init("pap_basin_3");
	flag::init("pap_basin_4");
	flag::init("pap_altar");
	
	// flags for the final defend
	flag::init("ritual_pap_ready");
	flag::init("ritual_pap_complete");
	
	// VO
	flag::init("story_vo_playing"); // set to preclude other opportunistic scripted VO triggers
	
	// final quest flags
	
	// EE flags
	
	/#
		level thread quest_devgui();
	#/
}

function on_player_connect()
{
	// TODO: set initial placement for quest key
}

function start_zod_quest()
{
	callback::on_connect( &player_death_watcher );
	
	level flag::wait_till( "start_zombie_round_logic" );
	
	// globals
	//level.custom_game_over_hud_elem = maps\mp\zm_prison_sq_final::custom_game_over_hud_elem;

	// ghost assets outside playable space
	prevent_theater_mode_spoilers();

	level thread setup_quest_key(); // Redemption's Key (setup key, play location-specific effects...)
	level thread setup_personal_items(); // prepare the personal item scripting (player must do some beast-mode things to make them appear and be accessible)
	level thread setup_defend_areas(); // setup ritual defend areas (the actual defend sequences)
	level thread setup_pap_door(); // set up the reveal-related scripting for the pap-chamber door (wall that explodes, revealing the PaP chamber)
	level thread setup_pap_chamber(); // set the pap chamber (threads for the gateworm basins to control the wallrun and islands, stuff related to the final defend sequence, etc.)
		
    if( IsDefined( level.gamedifficulty ) && level.gamedifficulty != 0 ) //easy
    {
    	//maps\mp\zm_prison_sq_final::final_flight_setup(); // Easter Egg - setup the final flight stuff (game-ending Alcatraz escape and showdown)   
    }
	
	// threads
	if( IsDefined( level.host_migration_listener_custom_func ) )
	{
		level thread [[ level.host_migration_listener_custom_func ]]();
	}
	else
	{
		level thread host_migration_listener(); // when host migrates this function refreshes effects
	}
	
	if( IsDefined( level.track_quest_status_thread_custom_func ) )
	{
		level thread [[ level.track_quest_status_thread_custom_func ]]();
	}
	else
	{
		level thread track_quest_status_thread(); // manage new quest plus
	}

	// opening VO
	zm_zod_quest_vo::opening_vo();
}

function prevent_theater_mode_spoilers()
{
	level flag::wait_till( "initial_blackscreen_passed" );

	// hide quest key
	mdl_key = GetEnt( "quest_key_pickup", "targetname" );
	mdl_key Ghost();
}

//
// REDEMPTION'S KEY
//

function setup_quest_key()
{
	mdl_key = GetEnt( "quest_key_pickup", "targetname" );
	mdl_key Show();
	//PlayFXOnTag( level._effect[ "ritual_key_glow" ], mdl_key, "tag_origin" );
		
	create_quest_key_pickup_unitrigger( mdl_key );
}

function create_quest_key_pickup_unitrigger( mdl_key )
{
	width = 128;
	height = 128;
	length = 128;

	mdl_key.unitrigger_stub = spawnstruct();
	mdl_key.unitrigger_stub.origin = mdl_key.origin;
	mdl_key.unitrigger_stub.angles = mdl_key.angles;
	mdl_key.unitrigger_stub.script_unitrigger_type = "unitrigger_box_use";
	mdl_key.unitrigger_stub.cursor_hint = "HINT_NOICON";
	mdl_key.unitrigger_stub.script_width = width;
	mdl_key.unitrigger_stub.script_height = height;
	mdl_key.unitrigger_stub.script_length = length;
	mdl_key.unitrigger_stub.require_look_at = false;
	mdl_key.unitrigger_stub.mdl_key = mdl_key;
	
	mdl_key.unitrigger_stub.prompt_and_visibility_func = &quest_key_trigger_visibility;
	zm_unitrigger::register_static_unitrigger( mdl_key.unitrigger_stub, &quest_key_trigger_think );
}
	
// self = unitrigger
function quest_key_trigger_visibility( player )
{
	b_is_invis = ( isdefined( player.beastmode ) && player.beastmode ) || !( ( isdefined( level.quest_key_can_be_picked_up ) && level.quest_key_can_be_picked_up ) );
	self setInvisibleToPlayer( player, b_is_invis );

	self SetHintString( &"ZM_ZOD_QUEST_RITUAL_PICKUP_QUEST_KEY" );
	
	return !b_is_invis;
}

// self = unitrigger
function quest_key_trigger_think()
{
	while( true )
	{
		self waittill( "trigger", player ); // wait until someone uses the trigger

		if( player zm_utility::in_revive_trigger() ) // revive triggers override trap triggers
		{
			continue;
		}
		
		if( ( player.is_drinking > 0 ) )
		{
			continue;
		}
	
		if( !zm_utility::is_player_valid( player ) ) // ensure valid player
		{
			continue;
		}

		level thread quest_key_trigger_pickup( self.stub );
		
		break;
	}
}

function quest_key_trigger_pickup( trig_stub )
{
	// hide key for now (don't delete, because we bring back the model for other stuff later)
	trig_stub.mdl_key Ghost();

	// turns off the unitrigger prompt
	level.quest_key_can_be_picked_up = false;
		
	// the team has the key	
	set_key_availability( true );
	
	// cause the trigger to hide itself
	trig_stub zm_unitrigger::run_visibility_function_for_all_triggers();
}

//
//	PERSONAL ITEMS
//

function setup_personal_items()
{
	level flag::init( "personal_item_canal" );

	level thread personal_item_crate_vfx();
	
	//ritual_magician_memento_magician
	level thread personal_item_junction();
	level thread personal_item_canal();
}

// TODO move these vfx to the client when there's a little more time
function personal_item_crate_vfx()
{
	// play Keeper magical glow on the remaining smashable boxes
	a_crates = array( "memento_boxer_drop_phrase", "memento_detective_drop_phrase", "memento_femme_drop_phrase" );
	foreach( str_crate in a_crates )
	{
		e_crate = GetEnt( str_crate, "targetname" );
		PlayFXOnTag( level._effect[ "cultist_crate_personal_item" ], e_crate, "tag_origin" );
	}
}

// zap the crane with electricity to turn it, bringing the crate into beast melee range
function personal_item_junction()
{
	level flag::wait_till( "power_on" + 20 );
	
	level clientfield::set( "junction_crane_state", 1 ); // activate the junction crane animation
	
	wait 3; // put in a wait for now... TODO: set up a function to reveal the personal item and play it off of a notetrack on the crane fxanim
	
	reveal_personal_item( "memento_magician_drop" );
}

// numbers on walls
// use randomized code to open the canal locker door
function personal_item_canal()
{
	e_door = GetEnt( "quest_personal_item_canal_door", "targetname" ); // locker door
	
	// wait for the flag that the keycode device sets when the correct code is entered
	a_flags = array( "personal_item_canal", "power_on" ); // will also respond to level flag "power_on", which gets set by the Open Sesame devgui command
   	level flag::wait_till_any( a_flags );

	// slide the door out of the way
	e_door MoveTo( e_door.origin - ( 0, 0, 64 ), 1 );
}

function personal_item_theater()
{
}
	
// this function is called by the smashable crate when the player breaks it
// set up a switch in this function to call the correct anim of the item tumbling into place, then unghost and make available the actual craftable pickup at the endpoint of the anim
// str_id will tell you which item it is
function reveal_personal_item( str_id )
{
	// destroy the added model of the Keeper-protective seal over the crate, if it's there
	mdl_phrase = GetEnt( str_id + "_phrase", "targetname" );
	if( isdefined( mdl_phrase ) )
	{
		mdl_phrase Delete();
	}
	
	// reveal the item	
	str_char_name = zm_zod_craftables::get_character_name_from_value( str_id ); // extract the character name from the name of the struct
	mdl_relic = level zm_craftables::get_craftable_piece_model( "ritual_" + str_char_name, "memento_" + str_char_name ); // replaced with the formula we use for the DEFINEs for simplicity
	s_body = struct::get( str_id + "_point", "targetname" ); // get drop-point struct to decide where to drop the piece
	mdl_relic.origin = s_body.origin; // warp the piece
	mdl_relic SetVisibleToAll(); // show the piece
	PlayFXOnTag( level._effect[ "memento_glow" ], mdl_relic, "tag_origin" ); // put a glow vfx on the dropped piece for greater visibility
}

//
//	RITUALS
//

function setup_defend_areas()
{
	Assert( !isdefined( level.a_o_defend_areas ), "setup_defend_areas() - defend areas have already been set up" );

	init_magic_circles(); // magic circles glow under the ritual tables while the ritual is active

	level.a_o_defend_areas = [];
	
	a_str_names = array( "boxer", "detective", "femme", "magician" );
	foreach( str_name in a_str_names )
	{
		setup_defend_area( str_name );
	}

	a_e_zombie_spawners						= GetEntArray( "ritual_zombie_spawner", "targetname" ); // get the special ritual spawner
	array::thread_all( a_e_zombie_spawners, &spawner::add_spawn_function, &zm_spawner::zombie_spawn_init);
        
	// PaP defend area is a special case
	level.a_o_defend_areas[ "pap" ] = new cAreaDefend();
	[[ level.a_o_defend_areas[ "pap" ] ]]->init( "defend_area_" + "pap", "defend_area_spawn_point_" + "pap" );
	[[ level.a_o_defend_areas[ "pap" ] ]]->set_luimenus( "ZodRitualProgress", "ZodRitualReturn", "ZodRitualSucceeded", "ZodRitualFailed" );
	[[ level.a_o_defend_areas[ "pap" ] ]]->set_trigger_visibility_function( &altar_trigger_visibility );
	[[ level.a_o_defend_areas[ "pap" ] ]]->set_external_functions( &ritual_prereq, &ritual_start, &ritual_succeed, &ritual_fail, "pap" );
	[[ level.a_o_defend_areas[ "pap" ] ]]->set_volumes( "defend_area_volume_" + "pap", "defend_area_volume_" + "pap" );
	[[ level.a_o_defend_areas[ "pap" ] ]]->start();
}

function setup_defend_area( str_name )
{
	Assert( !isdefined( level.a_o_defend_areas[ str_name ] ), "setup_defend_area( str_name ) - trying to setup a defend area that has already been set up" );
	
	level.a_o_defend_areas[ str_name ] = new cAreaDefend();
	[[ level.a_o_defend_areas[ str_name ] ]]->init( "defend_area_" + str_name, "defend_area_spawn_point_" + str_name );
	[[ level.a_o_defend_areas[ str_name ] ]]->set_luimenus( "ZodRitualProgress", "ZodRitualReturn", "ZodRitualSucceeded", "ZodRitualFailed" );
	[[ level.a_o_defend_areas[ str_name ] ]]->set_external_functions( &ritual_prereq, &ritual_start, &ritual_succeed, &ritual_fail, str_name );
	[[ level.a_o_defend_areas[ str_name ] ]]->set_volumes( "defend_area_volume_" + str_name, "defend_area_volume_" + str_name );
}

function pack_a_punch_init()
{
	level.pack_a_punch.triggers[ 0 ].machine Ghost(); // hide the default PaP model; we'll animate custom model in zm_zod_quest.csc
}

//
// COMMON RITUAL FUNCTIONS
//

// sets the clientfield and updates the defend area availability
function set_key_availability( b_is_available )
{
	level clientfield::set( "quest_key", b_is_available );
	foreach( o_defend_area in level.a_o_defend_areas )
	{
		thread [[ o_defend_area ]]->set_availability( b_is_available );
	}
}

function init_magic_circles()
{
	if( !isdefined( level.pap_quest ) )
	{
		level.pap_quest = SpawnStruct();
	}
	
	level.pap_quest.a_magic_circles_on = [];
	level.pap_quest.a_magic_circles_off = [];

	a_circles = GetEntArray( "quest_ritual_magic_circle_on", "targetname" );
	foreach( e_circle in a_circles )
	{
		// the magic circles are indexed by name of the player character associated with them
		str_name = zm_zod_craftables::get_character_name_from_value( e_circle.script_string ); // get the player character name from the script_string inherited from the ritual prefab
		level.pap_quest.a_magic_circles_on[ str_name ] = e_circle;
	}
	
	a_circles = GetEntArray( "quest_ritual_magic_circle_off", "targetname" );
	foreach( e_circle in a_circles )
	{
		// the magic circles are indexed by name of the player character associated with them
		str_name = zm_zod_craftables::get_character_name_from_value( e_circle.script_string ); // get the player character name from the script_string inherited from the ritual prefab
		level.pap_quest.a_magic_circles_off[ str_name ] = e_circle;
	}
	
	activate_all_magic_circles( false );
}

// turn all magic circles on or off, according to b_on
function activate_all_magic_circles( b_on = true )
{
	a_str_names = array( "boxer", "detective", "femme", "magician" );
	
	foreach( str_name in a_str_names )
	{
		activate_magic_circle( str_name, b_on );
	}
}

// n_index - 1-4 index of magic circle (locations correspond to the ZOD RITUAL VALUES in zm_zod_craftables)
// b_on - turn the magic circle on or not
function activate_magic_circle( str_name, b_on = true )
{
	if( str_name === "pap" )
	{
		return;
	}
	
	// visually activate decal
	if( b_on )
	{
		level.pap_quest.a_magic_circles_on[ str_name ] Show();
		level.pap_quest.a_magic_circles_off[ str_name ] Ghost();
	}
	else
	{
		level.pap_quest.a_magic_circles_on[ str_name ] Ghost();
		level.pap_quest.a_magic_circles_off[ str_name ] Show();
	}
}

function ritual_prereq( str_name )
{
	// for PaP Ritual - check if all 4 basins are ready
	if( str_name === "pap" )
	{
		a_basins = array( "pap_basin_1", "pap_basin_2", "pap_basin_3", "pap_basin_4" );
		foreach( str_basin in a_basins )
		{
			if( !( level flag::get( str_basin ) ) ) return false;
		}
		return true; // returns true if none of the basins returned false
	}
	
	b_is_quest_key_available = level clientfield::get( "quest_key" );
	
	if( level clientfield::get( "ritual_state_" + str_name ) == 2 )
	{
		b_has_ritual_previously_been_started = true;
	}
	else
	{
		b_has_ritual_previously_been_started = false;
	}
	
	if( ( b_is_quest_key_available && !b_has_ritual_previously_been_started ) || b_has_ritual_previously_been_started )
	{
		return true;
	}
	else
	{
		// play custom trigger-fail effects, etc.
		return false;
	}
}

function ritual_start( str_name )
{
	level notify( "ritual_" + str_name + "_start" );
	
	level flag::clear( "zombie_drop_powerups" ); // prevent powerups from dropping during the ritual
	
	if( str_name === "pap" ) // effects specific to the PAP ritual
	{
		// fill and activate the altar (updates the hintstring)
		level.pap_altar_filled = true;
		level.pap_altar_active = true;
		// place the model for Redemption's Key on the altar
		mdl_key = GetEnt( "quest_key_pickup", "targetname" );
		s_altar = struct::get( "defend_area_pap", "targetname" );
		mdl_key.origin = s_altar.origin;
		mdl_key Show();
		// energy path
		exploder::exploder( "fx_exploder_ritual_pap_altar_path" );
	}

	// the quest key is made unavailable, so only one ritual happens at a time	
	set_key_availability( false );
	
	// start the ritual clientside effects and anims
	level clientfield::set( "ritual_state_" + str_name, 2 );
	level clientfield::set( "ritual_current", get_enum_from_name( str_name ) );
	
	// activate ritual barrier
	set_ritual_barrier( str_name, true );
	// activate magic circle
	activate_magic_circle( str_name, true );

	// set duration of ritual (can adjust based on number of rituals completed)
	n_duration = level.zod_ritual_durations[ level.zod_n_rituals_completed ];
	ritual_current_progress = [[ level.a_o_defend_areas[ str_name ] ]]->set_duration( n_duration );

	level thread ritual_think( str_name );
}

function ritual_end()
{
	// kills the clientside effects and anim
	level clientfield::set( "ritual_current", 0 );
}

function ritual_think( str_name )
{
	level endon( "ritual_" + str_name + "_succeed" );
	level endon( "ritual_" + str_name + "_fail" );
	
	while( true )
	{
		ritual_current_progress = [[ level.a_o_defend_areas[ str_name ] ]]->get_current_progress();
		ritual_current_progress = Float( ritual_current_progress );
		/# PrintLn( "ritual_current_progress: " + ritual_current_progress ); #/
		level clientfield::set( "ritual_progress", ritual_current_progress );
		wait 0.05;
	}
}

function ritual_succeed( str_name )
{
	level.zod_n_rituals_completed++;
	
	level flag::set( "zombie_drop_powerups" ); // give back powerups
	
	// deactivate ritual barrier
	set_ritual_barrier( str_name, false );
	// deactivate magic circle
	activate_magic_circle( str_name, false );
	
	if( str_name == "pap" )
	{
		// energy path
		exploder::stop_exploder( "fx_exploder_ritual_pap_altar_path" );
		// special flags and stuff
		ritual_pap_succeed();
	}
	else
	{
		ritual_end(); // common ritual end stuff
	
		level notify( "ritual_" + str_name + "_succeed" );
		level flag::set("ritual_" + str_name + "_complete");
		level clientfield::set( "ritual_state_" + str_name, 3 );
		level clientfield::set( "quest_state_" + str_name, 3 );
		
		// let the ending anim wind down before revealing the key and truly finishing the ritual
		wait GetAnimLength( "p7_fxanim_zm_zod_redemption_key_ritual_end_anim" );
		
		// the quest key is made available again, so the players can start another ritual
		set_key_availability( true );
		
		// teleport the relic craftable in
		mdl_relic = level zm_craftables::get_craftable_piece_model( "ritual_pap", "relic_" + str_name );
		s_body = struct::get( "quest_ritual_item_placed_" + str_name, "targetname" );
		mdl_relic.origin = s_body.origin;
		mdl_relic SetVisibleToAll();
		PlayFXOnTag( level._effect[ "relic_glow" ], mdl_relic, "tag_origin" ); // put a glow vfx on the dropped piece for greater visibility
	}
}

function ritual_fail( str_name )
{
	level flag::set( "zombie_drop_powerups" ); // give back powerups

	// deactivate ritual barrier
	set_ritual_barrier( str_name, false );
	// deactivate magic circle
	activate_magic_circle( str_name, false );
	
	if( str_name == "pap" )
	{
		// energy path
		exploder::stop_exploder( "fx_exploder_ritual_pap_altar_path" );
		// special flags and stuff
		ritual_pap_fail();
	}
	
	// the quest key is made available again, so the players can start another ritual
	set_key_availability( true );
	
	level notify( "ritual_" + str_name + "_fail" );
	
	// reset progressive client fx
	level clientfield::set( "ritual_progress", 0 ); // reset
	wait 1;
	level clientfield::set( "ritual_current", 0 );
	
	// reset the table setup to the "ready" state, with the personal item placed but everything else rehidden
	level clientfield::set( "ritual_state_" + str_name, 1 );
	level clientfield::set( "quest_state_" + str_name, 3 );
}

function set_ritual_barrier( str_name, b_on )
{
	a_e_clip = GetEntArray(	"ritual_clip_" + str_name, "targetname" );
	foreach( e_clip in a_e_clip )
	{
		if( b_on )
		{
			e_clip SetVisibleToAll();
			exploder::exploder( "fx_exploder_ritual_" + str_name + "_barrier" );
		}
		else
		{
			e_clip SetInvisibleToAll();
			exploder::stop_exploder( "fx_exploder_ritual_" + str_name + "_barrier" );
		}
	}
}

function get_enum_from_name( str_name )
{
	switch( str_name )
	{
		case "boxer":
			return 1;
		case "detective":
			return 2;
		case "femme":
			return 3;
		case "magician":
			return 4;
		case "pap":
			return 5;
	}
	
	return 0;
}

//
// CUSTOM RITUAL FUNCTIONS
//

function ritual_pap_succeed()
{
	// play the gatestone explosion and portal vfx
	exploder::exploder( "fx_exploder_ritual_gatestone_explosion" );
	exploder::exploder( "fx_exploder_ritual_gatestone_portal" );
	
	// TODO: play the portal explosion anim
	
	// hide the parts of the portal model, post-anim
	e_portal = GetEnt( "pap_portal", "targetname" );
	for( i = 1; i < 5; i++ )
	{
		e_portal HidePart( "j_shard0" + i );
		// turn off the lightpaths
		exploder::stop_exploder( "fx_exploder_ritual_pap_basin_" + i + "_path" );
		// turn on BIGGER fire in basin
		e_basin = get_worm_basin( "pap_basin_" + i );
		PlayFXOnTag( level._effect[ "pap_basin_glow_lg" ], e_basin, "tag_origin" );
	}

	// gateworms hover and turn towards the front
	a_str_gateworm_held = array( "relic_boxer", "relic_detective", "relic_femme", "relic_magician" );
	foreach( str_gateworm_held in a_str_gateworm_held )
	{
		mdl_gateworm = GetEnt( "quest_ritual_" + str_gateworm_held + "_placed", "targetname" );
		mdl_gateworm MoveZ( 64, 3 );
		mdl_gateworm RotateYaw( 180, 3 );
	}

	// notifications and state updates
	level notify( "ritual_pap_succeed" );
	level flag::set( "ritual_pap_complete" );
	level clientfield::set( "ritual_current", 0 );
	level clientfield::set( "ritual_state_pap", 3 );
	level notify( "Pack_A_Punch_on" );
}

function ritual_pap_fail()
{
	level notify( "ritual_pap_fail" );
	level clientfield::set( "ritual_current", 0 );
	
	// deactivate altar
	level.pap_altar_active = false;
	clear_all_basins();
	// TODO: Redemption's Key returns to the pedestal (anim)
	// TODO: clear vfx / reset sound here
}

function get_completed_ritual_count()
{
	n_completed_rituals = 0;

	if( flag::get("ritual_boxer_complete") ) n_completed_rituals++;
	if( flag::get("ritual_detective_complete") ) n_completed_rituals++;
	if( flag::get("ritual_femme_complete") ) n_completed_rituals++;
	if( flag::get("ritual_magician_complete") ) n_completed_rituals++;
	if( flag::get("ritual_pap_complete") ) n_completed_rituals++;

	return n_completed_rituals;
}

//
// PACK-A-PUNCH DOOR
//

function setup_pap_door()
{
	e_pap_door = GetEnt( "pap_door", "targetname" );
	e_pap_door_clip = GetEnt( "pap_door_clip", "targetname" );
	// show the painted version of the key	
	e_pap_door HidePart( "tag_ritual_key_on" );
	e_pap_door ShowPart( "tag_ritual_key_off" );
	
	// 0. Initial fx
	exploder::exploder( "fx_exploder_ritual_pap_wall_smk" ); // play exploder for wall smoke until the wall has been exploded
	
	// 1. The Rituals Complete
	
	// light up inscriptions
	a_str_names = array( "boxer", "detective", "femme", "magician" );
	foreach( str_name in a_str_names )
	{
		e_pap_door thread pap_door_watch_for_ritual( str_name );
	}
	
	// wait until all player-character rituals are complete to do the explosion-event stuff
	a_str_ritual_flags = array( "ritual_boxer_complete", "ritual_detective_complete", "ritual_femme_complete", "ritual_magician_complete" );
	level flag::wait_till_all( a_str_ritual_flags );

	// 2. The Players Gather
	// central part of inscription glows
	e_pap_door ShowPart( "tag_ritual_key_on" );
	e_pap_door HidePart( "tag_ritual_key_off" );
	
	level thread pap_door_watch_for_explosion(); // thread to watch the number of players in the trigger
	level flag::wait_till( "pap_door_open" );
	
	// 3. The Door Opens
	// TODO: trigger fxanim and other fx
	e_pap_door SetInvisibleToAll();
	e_pap_door_clip MoveTo( e_pap_door.origin - ( 0, 0, 1024 ), 0.5 );
	wait 0.5;
	e_pap_door ConnectPaths();
	e_pap_door_clip ConnectPaths();
	exploder::stop_exploder( "fx_exploder_ritual_pap_wall_smk" );
	exploder::exploder( "fx_exploder_ritual_pap_wall_explo" );
}

function pap_door_watch_for_ritual( str_name )
{
	self HidePart( "tag_ritual_" + str_name + "_on" );
	self ShowPart( "tag_ritual_" + str_name + "_off" );

	level flag::wait_till( "ritual_" + str_name + "_complete" );
	
	// TODO: light up the part of the inscription corresponding to the completed ritual
	self ShowPart( "tag_ritual_" + str_name + "_on" );
	self HidePart( "tag_ritual_" + str_name + "_off" );
	level flag::wait_till( "pap_door_open" );

	// hide again after the door opens	
	self HidePart( "tag_ritual_" + str_name + "_on" );
	self HidePart( "tag_ritual_" + str_name + "_off" );
}

function pap_door_watch_for_explosion()
{
	level notify( "pap_door_watch_for_explosion" );
	level endon( "pap_door_watch_for_explosion" );
	
	t_pap_door = GetEnt( "pap_door_trigger", "targetname" );
	b_time_to_open = false;
	
	while( !b_time_to_open )
	{
		players = GetPlayers();
		
		b_time_to_open = true;
		foreach( player in players )
		{
			if( !( player IsTouching( t_pap_door ) ) )
			{
				b_time_to_open = false;
			}
		}
		
		wait 0.1;
	}
	
	level flag::set( "pap_door_open" );
}

//
// PACK-A-PUNCH CHAMBER
//

function setup_pap_chamber()
{
	//wait until everything is initialized before setting hint strings etc
	level flag::wait_till( "start_zombie_round_logic" );

	// hide the default pack_a_punch
	pack_a_punch_init();
		
	// triggers for the 4 gateworm basins in the PaP room
	hint_string = &"ZM_ZOD_QUEST_RITUAL_NEED_RELIC";
	func_trigger_visibility = &basin_trigger_visibility;
	func_trigger_thread = &basin_trigger_thread;
	for( i = 1; i < 5; i++ )
	{
		create_ritual_unitrigger( "pap_basin_" + i, hint_string, func_trigger_visibility, func_trigger_thread );
	}
	
	// threads to activate/deactivate the wallrun and island features, depending on the state of their associated flags (passed in as second parameter)
	level thread watch_wallrun( "quest_ritual_pap_wallrun_left",	"pap_basin_1",	"quest_ritual_pap_frieze_left" );
	level thread watch_island( "pap_chamber_middle_island_near",	"pap_basin_2" );
	level thread watch_island( "pap_chamber_middle_island_far",		"pap_basin_3" );
	level thread watch_wallrun( "quest_ritual_pap_wallrun_right",	"pap_basin_4",	"quest_ritual_pap_frieze_right" );
	
	a_flags = array( "pap_basin_2", "pap_basin_3" );
	level thread watch_central_traversal( a_flags );
}

function create_ritual_unitrigger( str_flag, hint_string, func_trigger_visibility, func_trigger_thread )
{
	width = 110;
	height = 90;
	length = 110;
		
	s_basin = struct::get( str_flag, "script_noteworthy" );
	s_basin.unitrigger_stub = spawnstruct();
	s_basin.unitrigger_stub.origin = s_basin.origin;
	s_basin.unitrigger_stub.angles = s_basin.angles;
	s_basin.unitrigger_stub.script_unitrigger_type = "unitrigger_box_use";
	s_basin.unitrigger_stub.hint_string = hint_string;
	s_basin.unitrigger_stub.cursor_hint = "HINT_NOICON";
	s_basin.unitrigger_stub.script_width = width;
	s_basin.unitrigger_stub.script_height = height;
	s_basin.unitrigger_stub.script_length = length;
	s_basin.unitrigger_stub.require_look_at = false;
	s_basin.unitrigger_stub.str_flag = str_flag; // pass this onto the unitrigger stub, so we can see it in the trigger thread
	
	s_basin.unitrigger_stub.prompt_and_visibility_func = func_trigger_visibility;
	zm_unitrigger::register_static_unitrigger( s_basin.unitrigger_stub, func_trigger_thread );
}

function basin_trigger_visibility( player )
{
	b_is_invis = ( isdefined( player.beastmode ) && player.beastmode ) || ( isdefined( self.stub.basin_filled ) && self.stub.basin_filled );
	self setInvisibleToPlayer( player, b_is_invis );
	
	str_gateworm_held = is_holding_relic( player.playernum );
	
	if( isdefined( str_gateworm_held ) )
	{
		self SetHintString( &"ZM_ZOD_QUEST_RITUAL_PLACE_RELIC" );
	}
	else
	{
		self SetHintString( self.stub.hint_string );
	}
	
	return !b_is_invis;
}

function altar_trigger_visibility( player )
{
	b_is_invis = ( isdefined( player.beastmode ) && player.beastmode ) || ( isdefined( level.pap_altar_active ) && level.pap_altar_active );
	self setInvisibleToPlayer( player, b_is_invis );

	// three possible states:
	//	is it too early to place Redemption's Key?
	//	is the altar ready for Redemption's Key?
	//	is the key in place, but gateworms need to be placed again?

	all_basins_filled = are_all_basins_filled();
	
	if( !all_basins_filled )
	{
		if( isdefined( level.pap_altar_filled ) ) // altar unready (gateworms still not all in place)
		{
			self SetHintString( &"ZM_ZOD_QUEST_RITUAL_PAP_REPLACE" ); // altar is filled; ready to kick off the defend event
		}
		else
		{
			self SetHintString( &"ZM_ZOD_QUEST_RITUAL_PAP_NOT_READY" );
		}
	}
	else // basins are all full; we can activate the ritual
	{
		self SetHintString( &"ZM_ZOD_QUEST_RITUAL_PAP_KICKOFF" );
	}
	
	return !b_is_invis;
}

// returns false if any of the basins are false
// returns true if none of the basins are false
function are_all_basins_filled()
{
	for( i = 1; i < 5; i++ )
	{
		if( !( level flag::get( "pap_basin_" + i ) ) )
		{
			return false; // returns false if any of the basins are false
		}
	}
	return true; // returns true if none of the basins are false
}

function clear_all_basins()
{
	for( i = 1; i < 5; i++ )
	{
		level flag::clear( "pap_basin_" + i );
	}
}

// return the name of the relic if e_triggerer is holding one; otherwise return undefined
function is_holding_relic( player_num )
{
	if ( !level flag::get("solo_game") )
	{
		// HACK: the clientfields are 1-4 in COOP, but 0 represents the player num in single player
		// Hopefully there is a better fix for this.
		player_num++;
	}
	
	// include this check, because the "holder_of" clientfield may return 0, which is a possible player number, so we need to avoid false positives
	someone_has_relic_boxer		= level clientfield::get( "quest_state_" + "boxer" );
	someone_has_relic_detective	= level clientfield::get( "quest_state_" + "detective" );
	someone_has_relic_femme		= level clientfield::get( "quest_state_" + "femme" );
	someone_has_relic_magician	= level clientfield::get( "quest_state_" + "magician" );

	// get the holder of each relic	
	who_has_relic_boxer		= level clientfield::get( "holder_of_" + "boxer" );
	who_has_relic_detective	= level clientfield::get( "holder_of_" + "detective" );
	who_has_relic_femme		= level clientfield::get( "holder_of_" + "femme" );
	who_has_relic_magician	= level clientfield::get( "holder_of_" + "magician" );
	
	// return the relic held by the player standing in the trigger, if applicable
	if( ( someone_has_relic_boxer === 4 )		&& ( who_has_relic_boxer === player_num )		)	return "relic_boxer";
	if( ( someone_has_relic_detective === 4 )	&& ( who_has_relic_detective === player_num )	)	return "relic_detective";
	if( ( someone_has_relic_femme === 4 )		&& ( who_has_relic_femme === player_num )		)	return "relic_femme";
	if( ( someone_has_relic_magician === 4 )		&& ( who_has_relic_magician === player_num )	)	return "relic_magician";

	// otherwise return undefined
	return undefined;
}

// TODO: handle player disconnect cases (on clear, return gateworm to its corresponding ritual altar)
function basin_trigger_thread()
{
	str_gateworm_held = undefined;
	
	// allow placing and removing the gateworm until the ritual is complete
	while ( !( level flag::get("ritual_pap_complete") ) )
	{
		self waittill( "trigger", e_triggerer );
		
		str_gateworm_held = is_holding_relic( e_triggerer.playernum ); // define str_gateworm_held to know that we can fill the basin; get which one it is so we know what model/UI to affect
		
		if( isdefined( str_gateworm_held ) )
		{
			self.stub.basin_filled = true;
			self.stub zm_unitrigger::run_visibility_function_for_all_triggers();
			str_flag = self.stub.str_flag;
			
			// set the flag that says the basin is occupied with a gateworm
			level flag::set( str_flag );
			
			// place the model for the appropriate gateworm into the basin (teleport model to the basin's struct, then unhide it - maybe we ultimately have some animation here?)
			mdl_gateworm = GetEnt( "quest_ritual_" + str_gateworm_held + "_placed", "targetname" );
			mdl_gateworm.origin = self.origin;
			mdl_gateworm Show();
			
			// play a lit up effect in the basin (unique worm basin effect)
			e_basin = get_worm_basin( str_flag );
			PlayFXOnTag( level._effect[ "pap_basin_glow" ], e_basin, "tag_origin" );
			
			// remove the gateworm from the player's inventory
			e_triggerer zm_craftables::player_remove_craftable_piece( "ritual_pap", "zod_quest_" + zm_zod_craftables::get_character_name_from_value( str_gateworm_held ) + "_relic" );
			level clientfield::set( "quest_state_" + zm_zod_craftables::get_character_name_from_value( str_gateworm_held ), 5 );  // update the UI quest item slot, removing memento
			if ( !level flag::get("solo_game") )
			{
				// Also clear the player's held item status
				level clientfield::set( "holder_of_" + zm_zod_craftables::get_character_name_from_value( str_gateworm_held ), 0 );  // this item slot is now held by no-one
			}
			
			// TODO: play vfx / sound here
			
			// wait until the basin clears (will be cleared by the PaP defend fail function - if the players start the final battle and fail, the gateworms return to them all, resetting the basins
			level thread return_gateworm_on_fail( self.stub, e_triggerer, str_gateworm_held, str_flag );
			level flag::wait_till_clear( str_flag );
		}
	}
	
	level thread zm_unitrigger::unregister_unitrigger( self.stub );
}

// get the worm basin entity corresponding to the given name (pap_basin_[1-4])
function get_worm_basin( str_flag )
{
	a_e_basins = GetEntArray( "worm_basin", "targetname" );
	foreach( e_basin in a_e_basins )
	{
		if( e_basin.script_noteworthy === str_flag )
		{
			return e_basin;
		}
	}
}

// wait until the basin clears (will be cleared by the PaP defend fail function - if the players start the final battle and fail, the gateworms return to them all, resetting the basins
function return_gateworm_on_fail( basin_trigger_stub, e_triggerer, str_gateworm_held, str_flag )
{
	level flag::wait_till_clear( str_flag );
	
	mdl_gateworm = GetEnt( "quest_ritual_" + str_gateworm_held + "_placed", "targetname" );
	
	// empty the basin of the gateworm (this parameter affects prompt visibility)
	if( isdefined( basin_trigger_stub ) )
	{
		basin_trigger_stub.basin_filled = false;
		basin_trigger_stub zm_unitrigger::run_visibility_function_for_all_triggers();
	}
	
	// hide the gateworm model
	mdl_gateworm Ghost();
	
	// return the gateworm to the player's inventory
	zm_craftables::player_get_craftable_piece( "ritual_pap", "zod_quest_" + zm_zod_craftables::get_character_name_from_value( str_gateworm_held ) + "_relic" );
	level clientfield::set( "quest_state_" + zm_zod_craftables::get_character_name_from_value( str_gateworm_held ), 4 ); 
	if ( !level flag::get("solo_game") )
	{
		// Also set the player's held item status
		level clientfield::set( "holder_of_" + zm_zod_craftables::get_character_name_from_value( str_gateworm_held ), e_triggerer.playernum );
	}
	
	// TODO: clear vfx / reset sound here
}

// enable / disable the wallrun depending on its associated basin flag
function watch_wallrun( str_wallrun, str_flag, str_model )
{
	// get wallrun trigger
	t_wallrun = GetEnt( str_wallrun, "targetname" );
	t_wallrun TriggerEnable( false ); // turn off trigger by default
	t_wallrun thread monitor_wallrun_trigger();

	mdl_frieze = GetEnt( str_model, "targetname" );
	mdl_frieze MoveTo( mdl_frieze.origin - ( 0, 0, 256 ), 1 ); // move down to start with (TODO: replace this with the disassembly animation when we get placeholder of that in)
		
	while( true )
	{
		flag::wait_till( str_flag ); // flag set -> the basin has a gateworm in it, so the frieze should activate for wallrun
		
		// activate wallrun trigger
		t_wallrun TriggerEnable( true );
		t_wallrun SetHintString( "" ); // don't show hintstring when running through trigger volume
		
		// turn up vfx
		exploder::exploder( "fx_exploder_ritual_" + str_flag + "_path" ); // beam from basin to gatestone
		gatestone_increment_power(); // turn up the power on the gatestone
		set_frieze_power( str_wallrun, true ); // wall frieze glowing-ash vfx
		
		// play assemble animation for frieze
		mdl_frieze MoveTo( mdl_frieze.origin + ( 0, 0, 256 ), 1 ); // move up (TODO: replace this with the assembly animation when we get placeholder of that in)
		
		flag::wait_till_clear( str_flag ); // flag cleared -> this means the basin is empty, so the frieze should now deactivate
		
		// deactivate wallrun trigger
		t_wallrun TriggerEnable( false );

		// turn down vfx
		gatestone_decrement_power();
		exploder::stop_exploder( "fx_exploder_ritual_" + str_flag + "_path" ); // beam from basin to gatestone
		set_frieze_power( str_wallrun, false ); // wall frieze glowing-ash vfx
		
		// play disassemble animation for frieze
		mdl_frieze MoveTo( mdl_frieze.origin - ( 0, 0, 256 ), 1 ); // move down (TODO: replace this with the disassembly animation when we get placeholder of that in)
	}
}

function set_frieze_power( str_wallrun, b_on )
{
	str_side = undefined;

	if( IsSubStr( str_wallrun, "left" ) )
	{
		str_side = "left";
	}
	else
	{
		str_side = "right";
	}
		
	if( b_on )
	{
		exploder::exploder( "fx_exploder_ritual_frieze_" + str_side + "_wallrun" );
	}
	else
	{
		exploder::stop_exploder( "fx_exploder_ritual_frieze_" + str_side + "_wallrun" );
	}
}

function gatestone_increment_power()
{
	gatestone_deactivate_power_level_indicator(); // if the gatestone has already been powered, stop the current exploder before starting the next one
	level.gatestone.n_power_level++; // increment power level and play exploder	
	gatestone_activate_power_level_indicator();
	update_chasm_awakening_vfx();
}

function gatestone_decrement_power()
{
	gatestone_deactivate_power_level_indicator(); // if the gatestone has already been powered, stop the current exploder before starting the next one
	level.gatestone.n_power_level--; // increment power level and play exploder	
	gatestone_activate_power_level_indicator();
	update_chasm_awakening_vfx();
}

function gatestone_set_power( n_power_level )
{
	gatestone_deactivate_power_level_indicator(); // if the gatestone has already been powered, stop the current exploder before starting the next one
	level.gatestone.n_power_level = n_power_level; // set new power level and play exploder
	gatestone_activate_power_level_indicator();
	update_chasm_awakening_vfx();
}

function gatestone_deactivate_power_level_indicator()
{
	// if the gatestone has already been powered, stop the current exploder before starting the next one
	if( level.gatestone.n_power_level > 0 )
	{
		exploder::stop_exploder( "fx_exploder_ritual_gatestone_" + level.gatestone.n_power_level + "_glow" );
	}
}

function gatestone_activate_power_level_indicator()
{
	// if the gatestone is currently powered, play the correct level of exploder
	if( ( level.gatestone.n_power_level > 0 ) && ( level.gatestone.n_power_level < 5 ) )
	{
		exploder::exploder( "fx_exploder_ritual_gatestone_" + level.gatestone.n_power_level + "_glow" );
	}
}

function update_chasm_awakening_vfx()
{
	if( level.gatestone.n_power_level > 0 )
	{
		exploder::exploder( "fx_exploder_ritual_chasm_awakened" );
	}
	else
	{
		exploder::stop_exploder( "fx_exploder_ritual_chasm_awakened" );
	}
}

// wallrun monitor thread for individual wallrun trigger volume..enable wallrun when people are touching it.
//	self is a trigger
function monitor_wallrun_trigger( t_wallrun )
{
	// toggle wallrun off and on depending on whether the player is inside the trigger volume and whether it is enabled
	while( true )
	{
		self waittill( "trigger", e_triggerer );
		
		if ( !( isdefined( e_triggerer.b_wall_run_enabled ) && e_triggerer.b_wall_run_enabled ) )
		{
			e_triggerer thread enable_wallrun( self );
		}
	}
}


//
//	Allow wallrun while you're in the trigger
//	self is a player
function enable_wallrun( t_trigger )
{
	self endon( "death" );
	
	self.b_wall_run_enabled = true;
	self AllowWallRun( true );

	while ( self IsTouching( t_trigger ) )
	{
		wait 0.05;
	}

	self AllowWallRun( false );
	self.b_wall_run_enabled = false;
}


// enable / disable an island depending on its associated basin
function watch_island( str_island, str_flag )
{
	// visual island
	e_island = GetEnt( str_island, "targetname" );
	e_island Ghost();
	// collision (player)
	e_clip = GetEnt( str_island + "_clip", "targetname" );
	e_clip SetInvisibleToAll();
	
	while( true )
	{
		flag::wait_till( str_flag );
		
		// turn up vfx
		gatestone_increment_power(); // turn up the power on the gatestone
		exploder::exploder( "fx_exploder_ritual_" + str_flag + "_path" ); // beam from basin to gatestone
		
		// show the island
		e_island Show();
		// TODO: play the island assembly anim
		// TODO: wait until the assembly anim is finished

		// activate collision once island has finished assembling
		e_clip SetVisibleToAll();
		
		flag::wait_till_clear( str_flag );
		
		// turn down vfx
		gatestone_decrement_power(); // turn down the power on the gatestone
		exploder::stop_exploder( "fx_exploder_ritual_" + str_flag + "_path" ); // beam from basin to gatestone
		
		// turn off collision immediately
		e_clip SetInvisibleToAll();
		
		// TODO: play the island disassembly anim
		// TODO: wait until the disassembly anim is finished
		
		// hide the island
		e_island Ghost();
	}
}

function watch_central_traversal( a_flags )
{
	self notify( "watch_central_traversal" );
	self endon( "watch_central_traversal" );
	
	str_traversal = "pap_mid_jump_72";
	nd_traversal = GetNode( str_traversal, "targetname" );
	
	// collision (monster)
	e_monster_clip = GetEnt( "pap_chamber_middle_island_monster_clip", "targetname" );
	
	while( true )
	{
		flag::wait_till_all( a_flags );
		e_monster_clip MoveTo( e_monster_clip.origin - ( 0, 0, 5000 ), 0.1 );
		LinkTraversal( nd_traversal );
		flag::wait_till_clear_any( a_flags );
		e_monster_clip MoveTo( e_monster_clip.origin + ( 0, 0, 5000 ), 0.1 );
		UnlinkTraversal( nd_traversal );
	}
}


//
// OTHER STUFF (UTILS, ETC.)
//

function host_migration_listener()
{
}

function track_quest_status_thread()
{
}

function player_death_watcher()
{
	if ( IsDefined( level.player_death_watcher_custom_func ) )
	{
		self thread [[ level.player_death_watcher_custom_func ]]();
		return;
	}

	self notify( "player_death_watcher" );
	self endon( "player_death_watcher" );

	/#
		IPrintLnBold( "player_death_watcher" );
	#/
}

function quest_devgui()
{
	/#
	// misc quest stuff
	SetDvar( "zod_quest_canal_locker", -1 );

	AddDebugCommand( "devgui_cmd \"ZM/Zod/Misc/Open Canal Locker/1\" \"zod_quest_canal_locker 1\"\n" );
	level thread watch_dvar_for_quest_canal_locker( "zod_quest_canal_locker" );
	
	AddDebugCommand( "devgui_cmd \"ZM/Zod/Give Redemption Key\" \"zod_give_redemption_key 1\"\n" );
	level thread watch_dvar_for_redemption_key();

	level thread zm_zod_util::setup_devgui_func( "ZM/Zod/Complete PaP Quest", "zod_pap_quest_completed", 1, &ritual_pap_succeed );
	#/
}

function watch_dvar_for_quest_canal_locker( str_dvar_name )
{
	while ( true )
	{
		n_val = GetDvarInt( str_dvar_name );
		if ( n_val > -1 )
		{
			/#
			IPrintLn( "open canal locker" );
			#/
			level flag::set( "personal_item_canal" );
			return; // one and done
		}
		wait 0.1;
	}
}

function watch_dvar_for_redemption_key( str_dvar_name )
{
	SetDvar( "zod_give_redemption_key", 0 );
	
	while ( true )
	{
		n_val = GetDvarInt( "zod_give_redemption_key" );
		
		if ( n_val )
		{
			set_key_availability( true );
			return; // one and done
		}
		
		wait 0.1;
	}
}

function watch_dvar_for_quest_ui( str_dvar_name, str_clientfield_name )
{
	while ( true )
	{
		n_val = GetDvarInt( str_dvar_name );
		if ( n_val > -1 )
		{
			/#
			IPrintLn( "set " + str_clientfield_name + " to " + n_val );
			#/
			level clientfield::set( str_clientfield_name, n_val );
			SetDvar( str_dvar_name, -1 );
		}
		wait 0.1;
	}
}
