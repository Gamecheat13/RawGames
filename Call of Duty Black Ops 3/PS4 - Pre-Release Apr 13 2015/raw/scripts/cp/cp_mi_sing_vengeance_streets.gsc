#using scripts\codescripts\struct;

#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\cp\_dialog;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;

#using scripts\shared\spawner_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\scene_shared;
#using scripts\cp\_spawn_manager;
#using scripts\cp\_util;
#using scripts\cp\_objectives;
#using scripts\cp\_skipto;
#using scripts\shared\stealth_status;

#using scripts\cp\_debug;

#using scripts\cp\cp_mi_sing_vengeance_util;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	            	    	   	                           	                               	                                	                                                              	                                                                          	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	              	                  	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\cp\_util;

#namespace vengeance_streets;


function skipto_streets_init( str_objective, b_starting )
{
	if ( b_starting )
	{
		vengeance_util::skipto_baseline( str_objective, b_starting );
	
		vengeance_util::init_hero( "hendricks", str_objective );
		level.ai_hendricks ai::set_ignoreall( true );
		level.ai_hendricks ai::set_ignoreme( true );
		
//		objectives::set( "cp_standard_follow_breadcrumb" , level.ai_hendricks );
	}
	
	level flag::set( "streets_begin" );
	
	streets_main( str_objective );
}

function streets_main( str_objective )
{
	level thread streets_hendricks();
	
	//setup patrollers
    arena_street_patroller_spawners = getentarray( "arena_street_patroller_spawners", "targetname" );
    foreach ( spawner in arena_street_patroller_spawners )
    {
    	spawner spawner::add_spawn_function( &vengeance_util::setup_patroller );
    }
    
    level.arena_street_patroller_spawners = spawner::simple_spawn( "arena_street_patroller_spawners" );
 
    level thread vengeance_util::spawn_police( "arena_street_police_spawners" );
	
	level flag::wait_till( "hendricks_out" );
	
	msg = level util::waittill_any_return( "police_rescued", "police_killed" );
		
	if ( isDefined( msg ) )
	{
		if ( msg == "police_rescued" )
		{
			level dialog::remote( "Hendricks: The officer is safe.  Keep moving to the safehouse." );
		}
		
		else if ( msg == "police_killed" )
		{
			level dialog::remote( "Hendricks: He's dead.  We have to keep moving to the safehouse." );
		}
	}
	
	level flag::set( "enable_arena_street_end_trigger" );
	
	//temp objective to leave arena street
	trig = level.skipto_triggers[ str_objective ];
	if ( isdefined( trig ) )
	{
		trig.objective_target = struct::get( "arena_street_obj_struct", "targetname" );
		objectives::set( "obj_arena_street", level.skipto_triggers[ str_objective ].objective_target );
	}
	
	if ( isdefined( trig ) )
	{
		trig trigger::wait_till();
	
		objectives::complete( "obj_arena_street", trig.objective_target );
	}
	
	
	foreach( e_player in level.players )
	{
		e_player Freezecontrols( true );
		e_player setClientUIVisibilityFlag( "hud_visible", 0 );
	}
	text_array = [];
	text_array[ 0 ] = "Players move through an alleyway";
	text_array[ 1 ] = "to reach the next section.";

	thread debug::debug_info_screen( text_array, 2 );
	
	
	skipto::objective_completed( "arena_street" );
	//skipto::teleport( "temple", undefined, undefined );
	level thread cleanup_arena_street();
	skipto::teleport_players( "dogleg_1", undefined );
	
	wait( 6.5 );
	
	foreach( e_player in level.players )
	{
		e_player Freezecontrols( false );
		e_player setClientUIVisibilityFlag( "hud_visible", 1 );
	}
}

function streets_hendricks()
{
	node = GetNode( "hendricks_street_start_node", "targetname" );
	level.ai_hendricks ai::force_goal( node );
	
	//"Hendricks: Contact.  Hold your fire.  54i all over the place.  They’ve got a large group of police in the middle."
	level.ai_hendricks dialog::say( "hend_contact_hold_your_0" );
	
	//"Hendricks: Spread out, let’s take out as many on the perimeter as we can, then take out the main group in the middle."
	level.ai_hendricks dialog::say( "hend_fan_out_let_s_take_0" );
	
	//"Hendricks: I’ll provide overwatch from above."
	level.ai_hendricks dialog::say( "hend_i_ll_provide_overwat_0" );
	
	level flag::set( "hendricks_out" );
	
	node = GetNode( "hendricks_street_delete_node", "targetname" );
	//level.ai_hendricks ai::force_goal( node );
	level.ai_hendricks setgoalnode( node );
	level.ai_hendricks waittill( "goal" );
//	wait( 6 );
	level.ai_hendricks util::stop_magic_bullet_shield();
	level.ai_hendricks Delete();
}

function skipto_streets_done( str_objective, b_starting, b_direct, player )
{
/*	
	trig = level.skipto_triggers[ str_objective ];
	if ( isdefined( trig ) )
	{
		objectives::complete( "cp_level_vengeance_temp", trig.objective_target );
		skipto::teleport( "temple", undefined, undefined );
	}
*/
}

//this should clean up all ents/scripting/etc...when the players cleared the area
function cleanup_arena_street()
{
	if ( isdefined( level.arena_street_patroller_spawners ) )
	{
		foreach ( enemy in level.arena_street_patroller_spawners ) 
		{
			if ( isdefined( enemy ) )
			{
				enemy stealth_status::clean_icon();
				enemy Delete();
			}
		}
	}
	
	level notify( "end_setup_police" );
	
	if ( isdefined( level.police ) )
	{
		foreach ( police in level.police ) 
		{
			if ( isdefined( police ) )
			{
				if ( isdefined( police.t_use ) )
				{
					police.t_use Delete();
				}
				
				objectives::complete( "cp_level_vengeance_police_rescue_waypoint", police );
				police Delete();
			}
		}
	}
	
	array::run_all( GetCorpseArray(), &Delete );
}
