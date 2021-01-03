#using scripts\codescripts\struct;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\cp\_load;
#using scripts\cp\_skipto;
#using scripts\cp\_util;

#using scripts\cp\cp_mi_cairo_ramses3_fx;
#using scripts\cp\cp_mi_cairo_ramses3_sound;

//shareds
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\math_shared;
#using scripts\shared\objpoints_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\codescripts\struct;
#using scripts\cp\_spawn_manager;
#using scripts\cp\_vehicle;
#using scripts\shared\vehicle_ai_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\colors_shared;
#using scripts\shared\turret_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\vehicles\_raps;
#using scripts\cp\_dialog;

#using scripts\shared\ai_shared;

//plaza scripts
#using scripts\cp\cp_mi_cairo_ramses_quad_tank_plaza;

#namespace freeway_battle;

function freeway_battle_main()
{
	freeway_battle_precache();

	freeway_battle();
}

function freeway_battle_precache()
{
	// DO ALL PRECACHING HERE
}

function freeway_battle()
{
	trigger::wait_till( "trig_spawn_vtol_drop_off" );
	
	level notify( "freeway_battle_started" );
	level flag::set( "start_vtol_robot_drop_1" );
	
	//vtol flies in and drops off robots
	vtol_robot_drop_off = GetEnt( "vtol_robot_drop_off_squad1", "targetname" );
	vh_vtol = vtol_robot_drop_off spawner::spawn();
	vh_vtol vtol_dropoff_squad( "robot_drop_off_squad1", "vtol_robot_squad_1" );
	
	level thread notify_color_trig_on_ai_count( "vtol_robot_squad_1", 1, "trig_color_post_vtol_dropoff" );
	
	//this is a trigger script flag set
	level flag::wait_till( "spawn_freeway_reinforcements" );
	
	level flag::set( "start_vtol_robot_drop_2" );
	
	a_fb_squad_2 = GetEntArray( "fb_squad_2", "targetname" );
	foreach( sp_robot in a_fb_squad_2 )
	{
		ai_robot = sp_robot spawner::spawn();
	}	
	
	vtol_robot_drop_off = GetEnt( "vtol_robot_drop_off_squad2", "targetname" );
	vh_vtol = vtol_robot_drop_off spawner::spawn();	
	vh_vtol vtol_dropoff_squad( "robot_drop_off_squad2", "vtol_robot_squad_2" );

	level thread notify_color_trig_on_ai_count( "fb_robot_squad_2", 2, "trig_color_post_fb_squad_2" );
	
	trigger::wait_till( "trig_color_post_fb_squad_2" );
	
	//spawn squad 3
	a_fb_squad_3 = GetEntArray( "fb_squad_3", "targetname" );
	foreach( sp_robot in a_fb_squad_3 )
	{
		ai_robot = sp_robot spawner::spawn();
	}	
	
	//notify trigger once ai group is cleared
	level thread notify_color_trig_on_ai_cleared( "fb_robot_squad_3", "trig_color_post_fb_squad_3" );	
	
	skipto::objective_completed( "freeway_battle" );
}

//self == vtol
function vtol_dropoff_squad( str_dropoff_node, str_squad_targetname )
{
	self endon( "death" );

	self.takedamage = false;
	self flag::init( "squad_dropped_off" );
	
	nd_start_node = GetVehicleNode( self.target, "targetname" );
	self thread vehicle::get_on_and_go_path( nd_start_node );	
	
	nd_robot_drop_off = GetVehicleNode( str_dropoff_node, "script_noteworthy" );
	nd_robot_drop_off waittill( "trigger" );
	self thread delete_on_end_node(); //TODO: script_noteworthy delete me is broken
	
	//stop helo
	self vehicle::set_speed( 0, 1000 );	
	
	wait 1;

	drop_robot_squad( str_squad_targetname );
	
	self flag::set( "squad_dropped_off" );
	
	//make sure the squad spawns in so we can wait until they are dead
	wait 1.5;
	
	self flag::clear( "squad_dropped_off" );
	self vehicle::script_resume_speed( "quad_dropped", 35 );	
}

function drop_robot_squad( str_name )
{
	a_s_spawn_spots = struct::get_array( str_name, "targetname" );
	
	foreach( s_spot in a_s_spawn_spots )
	{
		mdl_robot = util::spawn_model( s_spot.model, s_spot.origin, s_spot.angles );
		if( isdefined( s_spot.script_string ) )
		{
			mdl_robot.script_string = s_spot.script_string;
		}
		
		mdl_robot thread jump_off_vtol( s_spot.target );
	}
}

//self = robot script model
function jump_off_vtol( str_end_pos )
{
	s_end_pos = struct::get( str_end_pos, "targetname" );
	sp_robot = GetEnt( s_end_pos.target, "targetname" );
	
	self.e_anchor = util::spawn_model( "script_origin", self.origin, self.angles );
	self.e_anchor SetInvisibleToAll();	
	self LinkTo( self.e_anchor );
	
	n_random_time = RandomFloatRange( 0.5, 1.75 );
	
	self.e_anchor MoveTo( s_end_pos.origin, n_random_time );
	self.e_anchor waittill( "movedone" );
	
	if ( isdefined( self.script_string ) && self.script_string == "car_crush_robot" )
	{
		level thread scene::play( "p7_fxanim_cp_ramses_robot_car_crush_bundle" ); // Deletes by "script_objective" / "freeway_collapse"
	}
	
	self.e_anchor playsound ("fly_bot_hard_landing");
	
	self.e_anchor Delete();
	self Delete();

	ai_robot = sp_robot spawner::spawn();
}

function delete_on_end_node()
{
	self waittill( "reached_end_node" );
	self delete();
}

function notify_color_trig_on_ai_count( str_ai_group, n_count, str_color_trig )
{
	spawner::waittill_ai_group_ai_count( str_ai_group, n_count );
	trigger::use( str_color_trig, "targetname", undefined, false );		
}

function notify_color_trig_on_ai_cleared( str_ai_group, str_color_trig )
{
	spawner::waittill_ai_group_cleared( str_ai_group );
	trigger::use( str_color_trig, "targetname", undefined, false );		
	
	//TODO: make sense of this dialog under other conditions
	level flag::set( "freeway_battle_cleared" );
}
