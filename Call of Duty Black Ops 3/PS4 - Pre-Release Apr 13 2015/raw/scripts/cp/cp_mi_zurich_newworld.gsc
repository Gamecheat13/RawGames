// Shared
#using scripts\codescripts\struct;

#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_ai_shared;
#using scripts\shared\vehicle_shared;

// CP Common
#using scripts\cp\_ammo_cache;
#using scripts\cp\_load;
#using scripts\cp\_objectives;
#using scripts\cp\_oed;
#using scripts\cp\_skipto;
#using scripts\cp\_util;
#using scripts\cp\cybercom\_cybercom_gadget;
#using scripts\cp\cybercom\_cybercom_tactical_rig;

// Depts
#using scripts\cp\cp_mi_zurich_newworld_fx;
#using scripts\cp\cp_mi_zurich_newworld_sound;
#using scripts\cp\cp_mi_zurich_newworld_util;

// Events
#using scripts\cp\cp_mi_zurich_newworld_factory;
#using scripts\cp\cp_mi_zurich_newworld_lab;
#using scripts\cp\cp_mi_zurich_newworld_rooftops;
#using scripts\cp\cp_mi_zurich_newworld_train;
#using scripts\cp\cp_mi_zurich_newworld_underground;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#namespace newworld;

// PRECACHE














#precache( "fx", "weather/fx_snow_icicle_impact_50_nworld" );
#precache( "fx", "explosions/fx_exp_generic_lg" );		// TEMP for testing
#precache( "fx", "steam/fx_steam_leak_md_6sec_nworld" );
#precache( "fx", "electric/fx_elec_sarah_spawn" );
#precache( "fx", "player/fx_plyr_rez_out" );
#precache( "fx", "_t6/weapon/grenade/fx_smoke_willy_pete_sp" );
#precache( "fx", "steam/fx_steam_ambient_fill_nworld" );
#precache( "fx", "explosions/fx_exp_truck_slomo_nworld" );
#precache( "fx", "destruct/fx_dest_wall_nworld" );
#precache( "fx", "player/fx_plyr_ghost_trail_nworld" );
#precache( "fx", "electric/fx_elec_sparks_burst_blue" );
#precache( "fx", "explosions/fx_exp_train_car_nworld" );
#precache( "fx", "explosions/fx_exp_grenade_default" );

#precache( "model", "veh_t7_drone_hunter" );

#precache( "objective", "cp_level_new_breadcrumb_3d" );

#precache( "string", "CP_MI_ZURICH_NEWWORLD_ACTIVATE_DETACH_TRAIN" );

function main()
{
	init_clientfields();
	init_flags();
	init_fx();	// scripted fx
	cp_mi_zurich_newworld_fx::main();
	cp_mi_zurich_newworld_sound::main();

	setup_skiptos();

	// Set Level Vars
	level.b_enhanced_vision_enabled = true;	// Enables Enhanced Vision.  See _oed.gsc

	// Set Callbacks
	callback::on_spawned( &on_player_spawn );
	callback::on_loadout( &on_player_loadout );
	callback::on_connect( &set_tac_mode_flag );
	
	load::main();

	level thread level_threads();
}


function init_fx()
{
	level._effect[ "icicle_impact" ]			= "weather/fx_snow_icicle_impact_50_nworld";
	level._effect[ "large_explosion" ]			= "explosions/fx_exp_generic_lg";
	level._effect[ "pipe_steam" ]				= "steam/fx_steam_leak_md_6sec_nworld";
	level._effect[ "rez_in" ]					= "electric/fx_elec_sarah_spawn";
	level._effect[ "rez_out" ]					= "player/fx_plyr_rez_out";
	level._effect[ "smoke_grenade" ]			= "_t6/weapon/grenade/fx_smoke_willy_pete_sp";
	level._effect[ "steam_cloud" ]				= "steam/fx_steam_ambient_fill_nworld";
	level._effect[ "truck_explosion" ]			= "explosions/fx_exp_truck_slomo_nworld";
	level._effect[ "wall_break" ]				= "destruct/fx_dest_wall_nworld";
	level._effect[ "suspect_trail" ]			= "player/fx_plyr_ghost_trail_nworld";
	level._effect[ "wasp_hack" ]				= "electric/fx_elec_sparks_burst_blue";
	level._effect[ "train_explosion" ]			= "explosions/fx_exp_train_car_nworld";
	level._effect[ "frag_grenade" ]				= "explosions/fx_exp_grenade_default";
}

function init_clientfields()
{
	// Maglev Train
	clientfield::register( "world", 		"train_brake_flaps", 	1, 1, "int" );
	
	// UTIL
	clientfield::register( "actor",			"derez_ai_deaths",		1, 1, "int" );
	clientfield::register( "actor",			"ally_spawn_fx", 		1, 1, "int" );
	clientfield::register( "allplayers",	"player_spawn_fx",		1, 1, "int" );
	clientfield::register( "scriptmover",	"derez_model_deaths",	1, 1, "int" );
	clientfield::register( "toplayer", 		"player_snow_fx", 		1, 1, "int" );
	clientfield::register( "toplayer", 		"rumble_loop", 			1, 1, "int" );
}

function init_flags()
{
	level flag::init( "foundry_remote_hijack_enabled" );
	level flag::init( "ptsd_active" );
	level flag::init( "ptsd_area_clear" );
	level flag::init( "chase_train_station_glass_ceiling" );
}

//
//	level-wide threads
function level_threads()
{
	spawner::add_spawn_function_group( "civilian", "script_noteworthy", &civilian_spawn_function );
	//spawner::add_global_spawn_function( "axis", &newworld_util::ai_death_derez );
	
	array::thread_all( GetEntArray( "glass_break", "targetname" ), &glass_break );
	
	array::thread_all( GetEntArray( "panic_zone", "targetname" ), &panic_zone );
	
	array::thread_all( GetEntArray( "rooftops_wasp_trigger", "targetname" ), &rooftops_wasp_trigger );
	
	array::run_all( GetEntArray( "detach_bomb_trigger", "targetname" ), &TriggerEnable, false );
	
	level thread temp_train_light(); // TODO: Temp for Reza
	
	newworld_util::event_trigger_toggle( "train", "off" );
	newworld_util::steam_controller();
}


function on_player_spawn()
{
}


//	Override player loadout depending on the section.
function on_player_loadout()
{
	//	Replace Weapons
	self newworld_util::replace_weapons();

	// Abilities
	self newworld_util::replace_cyber_abilities();

	// Rigs
	self cybercom_tacrig::takeAllRigAbilities();
	self cybercom_tacrig::giveRigAbility( "cybercom_playermovement" , false ); //giving player ‘player movement’ rig, not upgraded (no double jump)
}


function setup_skiptos()
{
	//	Train
	skipto::add( "white_infinite_igc",	&newworld_train::skipto_white_infinite_igc_init, 		"white_infinite_igc",			&newworld_train::skipto_white_infinite_igc_done );

	//	Factory
	skipto::add( "pallas_igc",			&newworld_factory::skipto_pallas_igc_init, 				"pallas_igc",			&newworld_factory::skipto_pallas_igc_done );
	skipto::add( "factory_exterior",	&newworld_factory::skipto_factory_exterior_init, 		"factory_exterior",		&newworld_factory::skipto_factory_exterior_done );
	skipto::add( "alley", 				&newworld_factory::skipto_alley_init, 					"alley",				&newworld_factory::skipto_alley_done );
	skipto::add( "warehouse", 			&newworld_factory::skipto_warehouse_init, 				"warehouse",			&newworld_factory::skipto_warehouse_done );
	skipto::add( "foundry", 			&newworld_factory::skipto_foundry_init, 				"foundry",				&newworld_factory::skipto_foundry_done );
	skipto::add( "vat_room", 			&newworld_factory::skipto_vat_room_init, 				"vat_room",				&newworld_factory::skipto_vat_room_done );
	skipto::add( "inside_man_igc",		&newworld_factory::skipto_inside_man_igc_init, 			"inside_man_igc",		&newworld_factory::skipto_inside_man_igc_done );

	//	Rooftops
	skipto::add( "apartment_igc", 		&newworld_rooftops::skipto_apartment_igc_init, 			"apartment_igc",		&newworld_rooftops::skipto_apartment_igc_done );
	skipto::add( "chase", 				&newworld_rooftops::skipto_chase_init, 					"chase",				&newworld_rooftops::skipto_chase_done );
	skipto::add( "bridge_collapse_igc", &newworld_rooftops::skipto_bridge_collapse_igc_init, 	"bridge_collapse_igc",	&newworld_rooftops::skipto_bridge_collapse_igc_done );
	skipto::add( "rooftops",	 		&newworld_rooftops::skipto_rooftops_init, 				"rooftops",				&newworld_rooftops::skipto_rooftops_done );
	skipto::add( "construction_site",	&newworld_rooftops::skipto_construction_site_init, 		"construction_site",	&newworld_rooftops::skipto_construction_site_done );
	skipto::add( "glass_ceiling_igc",	&newworld_rooftops::skipto_glass_ceiling_igc_init, 		"glass_ceiling_igc",	&newworld_rooftops::skipto_glass_ceiling_igc_done );

	//	Underground
	skipto::add( "pinned_down_igc", 	&newworld_underground::skipto_pinned_down_igc_init, 	"pinned_down_igc",		&newworld_underground::skipto_pinned_down_igc_done );
	skipto::add( "subway", 				&newworld_underground::skipto_subway_init, 				"subway",				&newworld_underground::skipto_subway_done );
	skipto::add( "crossroads", 			&newworld_underground::skipto_crossroads_init, 			"crossroads",			&newworld_underground::skipto_crossroads_done );
	skipto::add( "construction",		&newworld_underground::skipto_construction_init,		"construction",			&newworld_underground::skipto_construction_done );
	skipto::add( "maintenance",			&newworld_underground::skipto_maintenance_init,			"maintenance",			&newworld_underground::skipto_maintenance_done );
	skipto::add( "water_plant", 		&newworld_underground::skipto_water_plant_init, 		"water_plant",			&newworld_underground::skipto_water_plant_done );
	skipto::add( "staging_room_igc", 	&newworld_underground::skipto_staging_room_igc_init, 	"staging_room_igc",		&newworld_underground::skipto_staging_room_igc_done );

	//DEV
	skipto::add_dev( "dev_timescale_test", 	&newworld_underground::dev_timescale_test, 				"DEV: Timescale Test" );

	//	Train
	skipto::add( "inbound_igc", 		&newworld_train::skipto_inbound_igc_init, 				"inbound_igc",			&newworld_train::skipto_inbound_igc_done );
	skipto::add( "train", 				&newworld_train::skipto_train_init, 					"train",				&newworld_train::skipto_train_done );
	skipto::add( "train_rooftop", 		&newworld_train::skipto_train_rooftop_init, 			"train_rooftop",		&newworld_train::skipto_train_rooftop_done );
	skipto::add( "detach_bomb_igc", 	&newworld_train::skipto_detach_bomb_igc_init, 			"detach_bomb_igc",		&newworld_train::skipto_detach_bomb_igc_done );

	//	Lab
	skipto::add_dev( "dev_lab", 			&newworld_lab::dev_lab_init,							"DEV:  Lab"	);
	skipto::add( "waking_up_igc", 		&newworld_lab::skipto_waking_up_igc_init, 				"waking_up_igc",		&newworld_lab::skipto_waking_up_igc_done );
}

function civilian_spawn_function()
{
	self.health = 1;
	self.team = "team3";	// because civs are set as "axis" by default, which is weird but... /shrug
	self ai::set_ignoreme( true );
	self ai::set_ignoreall( true );

	self ai::set_behavior_attribute( "panic" , false );

	self thread civilian_touch_death();
	self thread civilian_cleanup_death();
	self thread newworld_util::ai_death_derez();
}

// self == spawner
function civilian_think()
{
	ai = spawner::simple_spawn_single( self );
	ai endon( "death" );
	
	ai DisableAimAssist();
	
	if(!isdefined(level.a_ai_civilians))level.a_ai_civilians=[];
	if ( !isdefined( level.a_ai_civilians ) ) level.a_ai_civilians = []; else if ( !IsArray( level.a_ai_civilians ) ) level.a_ai_civilians = array( level.a_ai_civilians ); level.a_ai_civilians[level.a_ai_civilians.size]=ai;;

	str_linkto = self.script_linkto;
	str_animation = self.script_animation;
	
	if ( !IsDefined( self.script_animation ) )
	{
		ai ai::set_behavior_attribute( "panic" , true );
		ai thread newworld_util::delete_ai_at_path_end( true );

		return;
	}

	ai thread scene::play( str_animation, ai );
	ai waittill( "panic", nd_exit );

	wait RandomFloatRange( 0.0, 2.0 );
	
	ai scene::stop();
	
	ai ai::set_behavior_attribute( "panic" , true );

	if ( IsDefined( str_linkto ) )
	{
		a_nd = GetNodeArray( str_linkto, "script_linkname" );
		nd_exit = array::random( a_nd );
	}
	
	ai SetGoal( nd_exit, true, 64, 64 );
	ai waittill( "goal" );
	newworld_util::delete_ai( self, true );
}

function civilian_touch_death()
{
	self endon( "death" );
	
	self.e_trigger_touch = Spawn( "trigger_radius", self.origin, 1, 64, 90 );
	self.e_trigger_touch EnableLinkTo();
	self.e_trigger_touch LinkTo( self );
	
	self.e_trigger_touch waittill( "trigger", e_toucher );
	
	// don't die because you bumped into another civ
	if( isdefined( e_toucher.script_noteworthy ) && e_toucher.script_noteworthy == "civilian" )
	{
		return;
	}
	self Kill();
}

function civilian_whizby_death()
{
	self endon( "death" );
	
	self waittill( "bulletwhizby" );
	self Kill();
}

function civilian_cleanup_death()
{
	self waittill( "death" );
	
	self.e_trigger_touch util::self_delete();
}

function glass_break()
{
	v_origin = self.origin;
	
	self trigger::wait_till();
	
	GlassRadiusDamage( v_origin , 32 , 512 , 500 );
}

function panic_zone()	// self == trigger that starts civs panicking
{	
	e_volume = GetEnt( self.target, "targetname" );	// civs that are touching e_volume will start panicking
	a_nd_exit = GetNodeArray( e_volume.target, "targetname" );
	
	self waittill( "trigger", e_toucher );
	
	if(!isdefined(level.a_ai_civilians))level.a_ai_civilians=[];
	
	foreach ( ai in level.a_ai_civilians )
	{
		if ( IsDefined( ai ) && ai IsTouching( e_volume ) )
		{
			ai notify( "panic", array::random( a_nd_exit ) );
		}
	}
}

function rooftops_wasp_trigger()
{
	level endon( "rooftops_terminate" );

	a_s_wasps = struct::get_array( self.target );

	self trigger::wait_till();

	array::thread_all( a_s_wasps, &util::delay_notify, 0.05, "awaken" );
}

function temp_train_light()
{
	// TODO: TEMP HACKY FOR REZA. Remove this eventually.

	a_e_lights = GetEntArray( "train_light_test", "script_noteworthy" );

 	foreach( e_light in a_e_lights )
 	{
 		e_light.anchor = util::spawn_model( "tag_origin", e_light.origin );
		e_light LinkTo( e_light.anchor );
		e_light thread temp_train_light_move();
 	}
}

function temp_train_light_move()
{
	self.anchor MoveX( -128, 4 );
	wait 4;

	while ( true )
	{
		self.anchor MoveX( 256, 5 );
		wait 5;
		self.anchor MoveX( -256, 5 );
		wait 5;
	}
}

//self is player
function set_tac_mode_flag()
{
	self waittill( "tactical_mode_activated" );
	self.tmode_activated = true; // the cp_mi_zurich_newowrld_factory.gsc is listening for this	
}