#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\ai_shared;
#using scripts\shared\colors_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\scene_shared;

#using scripts\cp\_spawn_manager;
#using scripts\cp\_cic_turret;
#using scripts\cp\_dialog;
#using scripts\cp\_util;
#using scripts\cp\_skipto;
#using scripts\cp\_objectives;

#using scripts\shared\vehicle_ai_shared;
#using scripts\shared\vehicle_shared;

#using scripts\cp\cp_mi_sing_biodomes_util;
#using scripts\cp\cp_mi_sing_biodomes_cloudmountain;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

//#precache( "objective", "cp_level_biodomes_escape_cloud_mountain" );
//#precache( "objective", "cp_level_biodomes_escape_cloud_mountain_waypoint" );

#precache( "string", "CP_MI_SING_BIODOMES_FIGHTTOTHEDOME_RESCUE" );

function main()
{

}

//Fight To The Dome
function objective_fighttothedome_init( str_objective, b_starting )
{
	cp_mi_sing_biodomes_util::objective_message( "objective_fighttothedome_init" );
	
	objectives::set( "cp_level_biodomes_exfil" );
	
	//objectives::set( "cp_level_biodomes_escape_cloud_mountain_waypoint" , struct::get( "breadcrumb_fighttothedome" ) );
	//objectives::set( "cp_level_biodomes_escape_cloud_mountain" );
	
	if ( b_starting )
	{
		cp_mi_sing_biodomes_util::init_hendricks( str_objective );	
		cp_mi_sing_biodomes_cloudmountain::delete_all_window_states();
		cp_mi_sing_biodomes_cloudmountain::disable_cloudmountain_triggers();
		
		spawn_manager::enable( "sm_server_room_background" );
		
		level flag::wait_till( "all_players_spawned" );
		
		//make sure window doesn't show up after skipto
		GetEnt( "big_window_pristine" , "targetname" ) Delete();
	}
	
	level thread setup_rescue_objects();
	
	level thread cp_mi_sing_biodomes_cloudmountain::hendricks_server_control_room_door_open( true );
	
	e_clip = GetEnt( "control_room_ai_clip" , "targetname" );
	e_clip ConnectPaths();
	e_clip Delete();
	
	e_player_clip = GetEnt( "control_room_player_clip" , "targetname" );
	e_player_clip Delete();
	
	spawn_manager::enable( "sm_supertree_background_retreat" );
	
	level.ai_hendricks.ignoreall = false; //this is cleanup from the server room event where he is set to ignoreall true
	level.ai_hendricks SetGoal( struct::get( "hendricks_leaves_server_room" ).origin , true );
	
	level dialog::remote( "kane_we_got_it_go_now_0" );	//We got it! GO - now!
	level dialog::remote( "kane_vtol_inbound_thirty_0" );	//VTOL inbound thirty seconds, get to the roof.
	
	a_dialogue_lines = [];
	a_dialogue_lines[0] = "hend_ready_zipline_0"; //Ready Zipline!
	a_dialogue_lines[1] = "hend_ready_p_tracs_0"; //Ready P-Tracs.
	
	level.ai_hendricks dialog::say( cp_mi_sing_biodomes_util::vo_pick_random_line( a_dialogue_lines ), 3 );
	
	//have flying vehicles outside no longer ignore the player after some time
	a_background_ai = GetEntArray( "sp_server_room_background_ai", "targetname" );
	array::run_all( a_background_ai, &util::delay, 10, undefined, &ai::set_ignoreall, false );
}

function setup_rescue_objects()
{	
	level.a_rescue_ents = []; //using an array for easy cleanup later
	
	array::add( level.a_rescue_ents , GetEnt( "zip_trolley1" , "targetname" ) );
	array::add( level.a_rescue_ents , GetEnt( "zip_trolley2" , "targetname" ) );
	array::add( level.a_rescue_ents , GetEnt( "rescue_rope1" , "targetname" ) );
	array::add( level.a_rescue_ents , GetEnt( "rescue_rope2" , "targetname" ) );
	
	foreach ( ent in level.a_rescue_ents )
	{
		ent Show(); //these were hidden on level init
	}
	
	spawner::simple_spawn_single( "rescue_vtol" );
	t_use = GetEnt( "trig_rope_rescue" , "targetname" );
	t_use Show();
	t_use SetCursorHint( "HINT_NOICON" );
	t_use SetHintString( &"CP_MI_SING_BIODOMES_FIGHTTOTHEDOME_RESCUE" );
	
	a_visuals[0] = GetEnt( "zip_trolley2" , "targetname" );
	a_visuals[1] = GetEnt( "rescue_rope2" , "targetname" );
	
	e_hand = gameobjects::create_use_object( "allies" , t_use , a_visuals , ( 0, 0, 0 ) , undefined );
	
	// Setup use object params
	e_hand gameobjects::allow_use( "any" );
	e_hand gameobjects::set_use_time( 0.05 );						
	e_hand gameobjects::set_visible_team( "any" );
	e_hand gameobjects::set_3d_icon( "friendly", "t7_hud_prompt_push_64" );
	
	// Setup use object callbacks
	e_hand.onEndUse = &fighttothedome_completion;
}

function fighttothedome_completion( team , player , success )
{	
	foreach ( player in level.players )
	{
		player clientfield::set_to_player( "server_extra_cam", 0 );
		
		player EnableInvulnerability();
	}
	
	self gameobjects::disable_object(); //self = gameobject used to trigger this sequence	
	
	level thread scene::play( "cin_bio_11_03_fightdome_1st_escape" );
	
	util::screen_fade_out( 2 );
	
	skipto::objective_completed( "objective_fighttothedome" );
}

function objective_fighttothedome_done( str_objective, b_starting, b_direct, player )
{
	cp_mi_sing_biodomes_util::objective_message( "objective_fighttothedome_done" );
	
	objectives::complete( "cp_level_biodomes_exfil" );
}
