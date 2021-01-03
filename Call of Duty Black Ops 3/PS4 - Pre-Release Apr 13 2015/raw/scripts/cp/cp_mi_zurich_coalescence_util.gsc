#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\spawner_shared;

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\cp\_skipto;
#using scripts\cp\_util;

#namespace zurich_util;
//--------------------------------------------------------------------------------------------------
//	ZURICH UTIL
//--------------------------------------------------------------------------------------------------
function autoexec __init__sytem__() {     system::register("zurich_util",&__init__,undefined,undefined);    }
	
function __init__()
{	
	level.lighting_state = 0;
	callback::on_spawned( &on_player_spawned );
	callback::on_disconnect( &on_player_disconnect );
	callback::on_actor_killed( &ai_death_explosions );
	spawner::add_global_spawn_function( "axis", &ai_surreal_spawn_fx );

	setup_scene_callbacks();
	
	// clientfield setup
	init_client_field_callback_funcs();
}

function init_client_field_callback_funcs()
{
	// clientfield setup
	clientfield::register( "actor", 		"exploding_ai_deaths", 			1, 1, "int" );
	clientfield::register( "actor",			"ai_spawn_fx", 				1, 1, "int" );
}


function on_player_spawned()
{
	// self = player
	
	a_skiptos = skipto::get_current_skiptos();
	
	if ( IsDefined( a_skiptos ) )
	{	
		switch( a_skiptos[0] )
		{
			case "zurich":
				break;
			case "tree_circle":
				break;
			case "waterfall":
				break;		
			case "interrogation":
				break;
			case "clearing":
				break;
			case "clearing_end":
				break;					
			case "root_cairo":
				break;
			case "root_singapore":
				break;
			case "root_zurich":
				break;
			case "nest":
				break;
			case "zurich_outro":
				break;												
			default:
				break;
		}
	}
}

function on_player_disconnect()  // self = player
{

}

function setup_scene_callbacks()
{

}

//--------------------------------------------------------------------------------------------------
//	SURREAL AI SPAWN : Ravens
//--------------------------------------------------------------------------------------------------
function ai_surreal_spawn_fx()
{
	self endon( "death" );
	
	if ( self should_use_surreal_fx() )
	{
		self Ghost();
		self.ignoreall = true;

		self clientfield::set( "ai_spawn_fx", 1 );
			
		wait 2; //wait for spawn fx.
			
		self Show();
		self.ignoreall = false;			
	}	
}
	
//--------------------------------------------------------------------------------------------------
//	EXPLODING DEATHS : Ravens
//--------------------------------------------------------------------------------------------------
function ai_death_explosions()  // self = AI
{	
	if ( self should_use_surreal_fx() )
	{
		// two different ways for guys to explode on death. internally, this will pick the fastest one
		self thread explode_when_actor_becomes_corpse();
		self thread explode_on_ragdoll_start();
	}		
}	

function should_use_surreal_fx()  // self = AI
{
	return ( !IsVehicle( self ) && surreal_fx_enabled() && ( self.team != "allies" ) );
}

function surreal_fx_enabled()
{
	if(!isdefined(level.surreal_fx))level.surreal_fx=false;
	
	return level.surreal_fx;
}

//--------------------------------------------------------------------------------------------------
function enable_surreal_ai_fx( b_enabled = true, n_delay_time = 0 )
{
	level.surreal_fx = b_enabled;
	level.exploding_deaths_delay_time = n_delay_time;
}

function explode_on_ragdoll_start()
{
	self endon( "ai_explosion_death" );
	
	self waittill( "start_ragdoll" );
	
	death_explode_delay();
	
	if ( IsDefined( self ) )
	{
		self clientfield::set( "exploding_ai_deaths", 1 );
	}
	
	util::wait_network_frame();
	
	if ( IsDefined( self ) )
	{
		self Delete();
		self notify( "ai_explosion_death" );  // kill other explode thread
	}
}

function explode_when_actor_becomes_corpse()
{
	self endon( "ai_explosion_death" );
	
	self waittill( "actor_corpse", e_corpse );  // 'actor_corpse' sent when AI is deleted and is replaced with corpse entity
	
	death_explode_delay();
	
	if ( IsDefined( e_corpse ) )
	{
		e_corpse clientfield::set( "exploding_ai_deaths", 1 );
	}
	
	util::wait_network_frame();
	
	if ( IsDefined( e_corpse ) )
	{
		e_corpse Delete();	
	}
	
	if ( IsDefined( self ) )
	{
		self notify( "ai_explosion_death" );  // kill other explode thread
	}
}

function death_explode_delay()
{
	if ( IsDefined( level.exploding_deaths_delay_time ) )
	{
		wait level.exploding_deaths_delay_time;
	}	
}

