#using scripts\codescripts\struct;

#using scripts\shared\ai_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\compass;
#using scripts\shared\flag_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\lui_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\cp\_load;
#using scripts\cp\_skipto;
#using scripts\cp\_util;

#using scripts\cp\cp_mi_cairo_ramses_fx;
#using scripts\cp\cp_mi_cairo_ramses_sound;
#using scripts\cp\cp_mi_cairo_ramses_station_walk;
#using scripts\cp\cp_mi_cairo_ramses_utility;

                    

#namespace level_start;

function main()
{
	//precache();
	
	clientfield::set( "hide_station_miscmodels", 1 );
	clientfield::set( "turn_on_rotating_fxanim_fans" , 1 );
	clientfield::set( "start_fog_banks", 1 );
	
	level ramses_station_intro_igc();
	level skipto::objective_completed( "level_start" );
}

//function precache()
//{
//	// DO ALL PRECACHING HERE
//}

function init_heroes( str_objective )
{
	level.ai_hendricks = util::get_hero( "hendricks" );
	level.ai_rachel = util::get_hero( "rachel" );
	
    skipto::teleport_ai( str_objective );
}

function setup_players_for_station_walk() // self = player
{
	self endon( "death" );
	
	self allowsprint( false );
	self allowjump( false );	
	self SetLowReady( true );
	
	self thread tether_player_to_hendricks();
}

//self == player
function tether_player_to_hendricks()
{
	while( !isdefined( level.ai_hendricks ) )
	{
		wait 0.15;
	}
	
	self thread ramses_util::player_walk_speed_adjustment( level.ai_hendricks, "kill_player_walkspeed_adjustment", 128, 256, 0.3, 1 );
}

function setup_players_for_station_fight() // self = player
{
	self endon( "death" );
	
	self allowsprint( true );
	self allowjump( true );	
	self SetMoveSpeedScale( 1 );
	self SetLowReady( false );
	
	self notify( "kill_player_walkspeed_adjustment" );
}
                                                                                        
function ramses_station_intro_igc()
{	
	level flag::wait_till( "all_players_spawned" ); // If we don't wait here, player animation won't play
	
	level thread util::delay( 2, undefined, &scene::play, "cin_ram_01_01_enterstation_vign_loading" ); //-- timing change so that the player clip through a guy
//	level thread scene::play( "cin_ram_01_01_enterstation_vign_loading" );
	
	set_up_train();
	level notify ("start_music"); //TODO: once the music system is implemented this wont be a notify
	
	scene::add_scene_func( "cin_ram_01_01_enterstation_1st_ride", &station_intro_scene_init, "play" );	
	
	level thread enterstation_1st_ride_done_func();
	
	// TODO - Added shutdown notetrack to p_ram_01_01_enterstation_1st_ride to support this
	// This is a HACK because the "done" scene function never fires: station_intro_scene_done() 
	ramses_util::co_op_teleport_on_igc_end( "cin_ram_01_01_enterstation_1st_ride", "enterstation_1st_ride_teleport" );
	
	level thread chyron_text();
	wait 0.5; // so you don't see the warp from the init (the movie takes a bit to play)
	level scene::init( "cin_ram_01_01_enterstation_1st_ride" );
	wait 3.0; //chyron text is 6 seconds long TODO: remove once we actually have chyron text
	level scene::play( "cin_ram_01_01_enterstation_1st_ride" );
}

function chyron_text()
{
	level flag::set( "start_level" );
	level thread lui::play_movie( "cp_ramses1_fs_chyron", "fullscreen", true );
}

function set_up_train()
{
	foreach( player in level.players )
	{
		player thread enterstation_1st_ride_arrival_rumble();
		player thread enterstation_1st_ride_stop_rumble();
	}
	
	mdl_train_car_main = GetEnt( "traincar_primary", "targetname" );
	mdl_train_car_main.script_objective = "interview_dr_nasser";
	attach_extracam_to_traincar( mdl_train_car_main );
	
	mdl_train_car_main link_ents( "lgt_subway_car", "script_noteworthy" ); // Lights and probes - if new lights or probes aren't working make sure they are ServerSide and have the appropriate script_noteworthy
	mdl_train_car_main link_ents( "traincar_primary_cab" );
		
	util::wait_network_frame();
}

function station_intro_scene_init( a_ents )
{
	mdl_train_car_main = a_ents[ "traincar_primary" ];

	turn_on_reflection_extracam();
	
	mdl_train_car_main waittill( "stopped" ); // Sent via notetrack - TODO: eventually need one exported exactly where music needs to start
	
	level notify ("train_done");  //notify kicks off music track - TODO: may want to just send this from a notetrack
}

function enterstation_1st_ride_done_func()
{
	level waittill( "cin_ram_01_01_enterstation_1st_ride_done" );
	
	util::clear_streamer_hint();
	
	level.ai_hendricks SetDedicatedShadow( false );
}

function attach_extracam_to_traincar( e_train )
{
	e_train clientfield::set( "attach_cam_to_train", 1 );
}

function enterstation_1st_ride_arrival_rumble() // self = player
{	
	self endon( "disconnect" );
	
	// notetrack in p_ram_01_01_enterstation_1st_ride
	level endon( "cp_cairo_ramses_subway_rumble_loop_stop" );
	
	while( 1 )
	{
		self PlayRumbleOnEntity( "tank_rumble" );
		wait 1.0;
	}
}

function enterstation_1st_ride_stop_rumble() // self = player
{
	self endon( "disconnect" );

	// notetrack in p_ram_01_01_enterstation_1st_ride
	level waittill( "cp_cairo_ramses_subway_stop_rumble" );
	
	self PlayRumbleOnEntity( "tank_fire" );
}

function turn_on_reflection_extracam()
{
	foreach( e_player in level.players )
	{
		e_player clientfield::set_to_player( "intro_reflection_extracam", 1 );
	}
}

function turn_off_reflection_extracam()
{
	foreach( e_player in level.players )
	{
		e_player clientfield::set_to_player( "intro_reflection_extracam", 0 );
	}
}

// Self is script model
function link_ents( str_name, str_key = "targetname" )
{
	a_e_ents = GetEntArray( str_name, str_key ); 
	
	foreach( e_ent in a_e_ents )
	{
		e_ent LinkTo( self );
		e_ent.script_objective = "interview_dr_nasser";
		
//		/#self thread ramses_util::debug_link_probe( e_lighting_ent );#/
	}
}

// Self is script model
function link_players()
{
	foreach( e_player in level.players )
	{
		e_player SetOrigin( self.mdl_temp_link.origin );
		e_player SetPlayerAngles( self.angles );
		e_player PlayerLinkTo( self.mdl_temp_link, undefined, 0, 0, 0, 0, 0 );
	}
}
