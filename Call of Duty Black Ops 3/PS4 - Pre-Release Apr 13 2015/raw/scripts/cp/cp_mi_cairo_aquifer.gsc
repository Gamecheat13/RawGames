#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\hud_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\util_shared;
#using scripts\shared\array_shared;
#using scripts\cp\_dialog;
#using scripts\cp\_hacking;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\cp\_load;
#using scripts\cp\_util;
#using scripts\cp\_skipto;
#using scripts\cp\_debug;
#using scripts\cp\_dialog;

#using scripts\cp\cp_mi_cairo_aquifer_interior;
#using scripts\cp\cp_mi_cairo_aquifer_boss;
#using scripts\cp\cp_mi_cairo_aquifer_fx;
#using scripts\cp\cp_mi_cairo_aquifer_sound;
#using scripts\shared\vehicle_shared;
#using scripts\shared\flag_shared;
#using scripts\cp\cp_mi_cairo_aquifer_utility;
#using scripts\cp\_objectives;
#using scripts\cp\cp_mi_cairo_aquifer_aitest;
#using scripts\cp\cp_mi_cairo_aquifer_objectives;

#precache( "fx", "explosions/fx_exp_generic_lg" );
#precache( "fx", "destruct/fx_dest_ramses_plaza_glass_bldg" );
#precache( "fx", "explosions/fx_exp_equipment_lg" );

#precache( "lui_menu_data", "vehicle.outOfRange" );

function main()
{
	precache();
	skipto_setup();
	init_flags();

	billboard();
	
	cp_mi_cairo_aquifer_fx::main();
	cp_mi_cairo_aquifer_sound::main();
	cp_mi_cairo_aquifer_aitest::main();

//	cp_mi_cairo_aquifer_hackobjs::main();
	
	callback::on_connect( &on_player_connected );
	callback::on_spawned( &on_player_spawned );
	callback::on_loadout( &on_player_loadout );
	
	load::main();

	SetDvar( "compassmaxrange", "2100" );	// Set up the default range of the compass
}

function init_flags()
{
	level flag::init("end_battle");
}

function skipto_setup()
{
	skipto::add( "level_long_fly_in", &aquifer_obj::skipto_level_long_fly_in_init, "level_long_fly_in", &aquifer_obj::skipto_level_long_fly_in_done );
	skipto::add( "post_intro", &aquifer_obj::skipto_post_intro_init, "post_intro", &aquifer_obj::skipto_post_intro_done );
	skipto::add( "destroy_defenses", &aquifer_obj::skipto_defenses_init, "Destroy AA defenses", &aquifer_obj::skipto_defenses_done );
	skipto::add( "hack_terminals", &aquifer_obj::skipto_hack_init, "Locate Hyperion", &aquifer_obj::skipto_hack_done );
	skipto::add( "water_room", &aquifer_obj::skipto_water_room_init, "Confront Hyperion", &aquifer_obj::skipto_water_room_done );
	skipto::add( "destroy_defenses2", &aquifer_obj::skipto_defenses_init2, "Support Egyptian Forces", &aquifer_obj::skipto_defenses_done2 );
	skipto::add( "hack_terminals2", &aquifer_obj::skipto_hack_init2, "Neutralize Enemy Air Support", &aquifer_obj::skipto_hack_done2 );
	skipto::add( "destroy_defenses3", &aquifer_obj::skipto_defenses_init3, "Destroy Remaining AA", &aquifer_obj::skipto_defenses_done3 );
	skipto::add( "hack_terminals3", &aquifer_obj::skipto_hack_init3, "On Hyperion's Trail", &aquifer_obj::skipto_hack_done3 );
	skipto::add( "breach_hangar", &aquifer_obj::skipto_breach_init, "Hangar Breach", &aquifer_obj::skipto_breach_done );
	skipto::add( "post_breach", &aquifer_obj::skipto_post_breach_init, "Post Breach", &aquifer_obj::skipto_post_breach_done );
	skipto::add( "sniper_boss", &aquifer_obj::skipto_boss_init, "Hyperion Battle", &aquifer_obj::skipto_boss_done );
	skipto::add( "hideout", &aquifer_obj::skipto_hideout_init, "Hyperion's hideout", &aquifer_obj::skipto_hideout_done );
	skipto::add( "exfil", &aquifer_obj::skipto_exfil_init, "Exfil", &aquifer_obj::skipto_exfil_done );
		
	skipto::default_skipto( "level_long_fly_in" );
	
	level.skipto_triggers = [];
	a_trigs = GetEntArray( "objective", "targetname" );
	foreach( trig in a_trigs )
	{
		if ( isdefined( trig.script_objective ) )
		{
			level.skipto_triggers[ trig.script_objective ] = trig;
		}
	}
}

function billboard()
{
	skipto::add_billboard( "level_long_fly_in", "INTRO", "Pacing", "Small", "BLOCKOUT" );
	skipto::add_billboard( "post_intro", "POSTINTRO", "Pacing", "Large", "BLOCKOUT" );
	skipto::add_billboard( "destroy_defenses", "DESTROY AA DEFENSES", "Aerial Combat", "Large", "BLOCKOUT" );
	skipto::add_billboard( "hack_terminals", "LOCATE HYPERION", "Combat", "Large", "BLOCKOUT" );
	skipto::add_billboard( "water_room", "CONFRONT HYPERION", "Pacing", "Small", "BLOCKOUT" );
	skipto::add_billboard( "destroy_defenses2", "SUPPORT EGYPTIANS", "Combat", "Medium", "BLOCKOUT" );
	skipto::add_billboard( "hack_terminals2", "NEUTALIZE ENEMY AIRCRAFT", "Aerial Combat", "Large", "BLOCKOUT" );
	skipto::add_billboard( "destroy_defenses3", "DESTROY REMAINING AA DEFENSES", "Combat", "Large", "BLOCKOUT" );
	skipto::add_billboard( "hack_terminals3", "ON HYPERION'S TRAIL", "Pacing", "Large", "BLOCKOUT" );
	skipto::add_billboard( "breach_hangar", "BREACH", "Moment", "Small", "BLOCKOUT" );
	skipto::add_billboard( "post_breach", "CHASE", "Combat", "Size", "BLOCKOUT" );
	skipto::add_billboard( "sniper_boss", "BOSS", "Battle", "Medium", "BLOCKOUT" );
	skipto::add_billboard( "hideout", "HIDEOUT", "Story", "Medium", "BLOCKOUT" );
	skipto::add_billboard( "exfil", "EXFIL", "Run", "High", "BLOCKOUT" );
}

function precache()
{
	// DO ALL PRECACHING HERE
	level flag::init( "hyperion_start_tree_scene" );
	level flag::init( "minions_clear" );
	level flag::init( "start_aquifer_objectives" );
	level flag::init( "breach_hangar_active" );
	level flag::init( "hold_for_debug_splash" );
	level flag::init( "on_hangar_exterior" );
	level flag::init( "player_active_in_level" );
	level flag::init( "water_room_checkpoint" );
	if ( ! level flag::exists( "destroy_defenses3_completed" ) )
	{
		level flag::init( "destroy_defenses3_completed"  );
		level flag::init( "destroy_defenses3_started" );
		level flag::init( "destroy_defenses3" );
		level flag::init( "hack_terminals3_started" );
		level flag::init( "hack_terminals3" );
		level flag::init( "hack_terminals3_completed" );
		
	}
	
	level.fast_hack = false;
	level.hack_upload_range =384;
	
	
	thread aquifer_util::setup_reusable_destructible();
}

function on_player_connected()
{
	if ( !IsDefined( level.cur_vtol_num ) )
	{
		level.cur_vtol_num = 1;
	}
	
	if ( !IsDefined( level.vtol_player_array ) )
	{
		level.vtol_player_array = [];
	}
}

function on_player_spawned()
{
	
}

function on_player_loadout()
{
	self endon( "disconnect" );
	self endon( "death" );
	
	self.my_heightmap = "none";
	level flag::set("player_active_in_level");
	
	if ( level flag::exists( "level_long_fly_in_completed" ) && !level flag::get( "level_long_fly_in_completed" ) )
	{
		level notify( "begin_intro_dialog" );
		
		intro_text = [];
		intro_text[ intro_text.size ] = " ";
//		intro_text[ intro_text.size ] = "High speed flight towards aquifer";
//		intro_text[ intro_text.size ] = "Jets exploding, tanks and ground troops fighting, war ambience";
//		
		self thread debug::debug_info_screen( intro_text,1 );
		
		if ( !IsDefined( level.vtol_player_array[ self GetXuid() ] ) )
		{
			level.vtol_player_array[ self GetXuid() ] = level.cur_vtol_num;
			level.cur_vtol_num++;
		}
		
		vtolname = "player" + level.vtol_player_array[ self GetXuid() ] + "_vtol";
		self.pvtol = GetEnt( vtolname, "targetname" );
		
		if( !IsDefined( self.pvtol ) )
		{
			IPrintLnBold( "missing a votl for player " + vtolname );
		}

		self.pvtol vehicle::god_on();
		self.pvtol DisableDriverFiring( true );
		self.pvtol SetPathTransitionTime( 0.0 );
		self.pvtol thread vehicle::get_on_path( "Vtol_intro_long_path_start" );
		
		wait 1;
		
		org = self.pvtol GetTagOrigin( "tag_driver_camera");
		ang = self.pvtol GetTagAngles( "tag_driver_camera");
		self setorigin( org );
		self setplayerangles( ( ang[ 0 ], ang[ 1 ], ang[ 2 ] ) );
		
		self.pvtol UseVehicle( self, 0 );
		self.pvtol MakeVehicleUnusable();
		self SetControllerUIModelValue( "vehicle.outOfRange", true ); // hide HUD controls

		self.pvtol thread vehicle::go_path();
		
		self.pvtol waittill( "reached_end_node" );
		
		level notify( "disengage_autopilot" );

		self.pvtol DisableDriverFiring( false );
		
		self thread aquifer_util::watch_player_call_vtol( true );
		
	}
//	else if ( level flag::exists( "hack_terminals2" ) && !level flag::get( "hack_terminals2_completed" ) )
	else if ( level flag::exists( "hack_terminals3" ) && !level flag::get( "hack_terminals3_completed" ) )
	{
		if ( !IsDefined( level.vtol_player_array[ self GetXuid() ] ) )
		{
			level.vtol_player_array[ self GetXuid() ] = level.cur_vtol_num;
			level.cur_vtol_num++;
		}
		
		vtolname = "player" + level.vtol_player_array[ self GetXuid() ] + "_vtol";
		self.pvtol = GetEnt( vtolname, "targetname" );
		self.pvtol vehicle::god_on();
		self.pvtol DisableDriverFiring( false );
		org = self.pvtol GetTagOrigin( "tag_driver_camera");
		ang = self.pvtol GetTagAngles( "tag_driver_camera");
		self setorigin( org );
		self setplayerangles( ( ang[ 0 ], ang[ 1 ], ang[ 2 ] ) );
		
		self.pvtol MakeVehicleUsable();
		self.pvtol UseVehicle( self, 0 );
		self.pvtol MakeVehicleUnusable();
		
		self thread aquifer_util::watch_player_call_vtol( true );
	}
	//Set up the heightmap for this player.
//	if ( level flag::exists( "hack_terminals2" ) && !level flag::get( "hack_terminals2_completed" ) )
	if ( level flag::exists( "hack_terminals3" ) && !level flag::get( "hack_terminals3_completed" ) )
	{
		if ( level flag::exists( "hack_terminals" ) && !level flag::get( "hack_terminals_completed" ) )
			self thread aquifer_util::player_init_heightmap_intro_state( true );
		else if ( level flag::exists( "hack_terminals2" ) && !level flag::get( "hack_terminals2_completed" ) )
			self thread aquifer_util::player_init_heightmap_obj3_state( true );
		else
			self thread aquifer_util::player_init_heightmap_breach_state( true );
	}
}


