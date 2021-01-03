#using scripts\codescripts\struct;

#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
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
#using scripts\cp\_dialog;
#using scripts\shared\stealth_status;
#using scripts\shared\vehicles\_hunter;
#using scripts\shared\colors_shared;

#using scripts\cp\cp_mi_sing_vengeance_util;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\cp\_util;

#namespace vengeance_temple;

function skipto_temple_init( str_objective, b_starting )
{	
	vengeance_util::skipto_baseline( str_objective, b_starting );
	
	if ( b_starting )
	{
	}
	
	vengeance_util::init_hero( "hendricks", str_objective );
	
	temple_main( str_objective );
}

function temple_main( str_objective )
{
	level thread temple_vo();
	level.ai_hendricks thread setup_temple_hendricks();
	level thread temple_hunters();
	
	level thread setup_breakable_garden_windows();
	
	//setup patrollers
    level.temple_patroller_spawners = spawner::simple_spawn( "temple_patroller_spawners", &vengeance_util::setup_patroller );
	
	//temp objective to leave temple
	trig = level.skipto_triggers[ str_objective ];
	trig.objective_target = SpawnStruct();
	trig.objective_target.origin = trig.origin;
	objectives::set( "regroup_radio_contact", level.skipto_triggers[ str_objective ].objective_target );
}

function temple_hunters()
{
	level.temple_hunters = spawner::simple_spawn( "temple_hunters", &temple_hunters_spawn );
}

function temple_hunters_spawn()
{
	
}

function setup_temple_hendricks()
{
	//endon broke stealth
	self endon( "death" );
	
	self ai::set_ignoreall( true );
	self ai::set_ignoreme( true );
	self colors::disable();
	self ai::set_behavior_attribute( "cqb", true );
	self.goalradius = 32;
	objectives::set( "cp_standard_follow_breadcrumb", self );
	
	node = getnode( "temple_hendricks_node_05", "targetname" );
	self thread ai::force_goal( node, node.radius );
	self waittill( "goal" );
	level notify( "temple_vo" );
	
	wait 10.0;
	
	objectives::complete( "cp_standard_follow_breadcrumb", self );
	self Delete();
}

function temple_vo()
{
	level waittill( "temple_vo" );
	
	//Hendricks: Lots of movement down there  – we need to work our way through to get to the safehouse.
	//level dialog::remote( "hend_lots_of_movement_dow_0" );
	level.ai_hendricks dialog::say( "hend_lots_of_movement_dow_0" );
	
	wait 1;
	
	//Hendricks: I’ll cover from above, move out.
	//level dialog::remote( "hend_i_ll_cover_from_abov_0" );
	level.ai_hendricks dialog::say( "hend_i_ll_cover_from_abov_0" );	
}

function skipto_temple_done( str_objective, b_starting, b_direct, player )
{
	trig = level.skipto_triggers[ str_objective ];
	if ( isdefined( trig ) )
	{
		objectives::complete( "regroup_radio_contact", trig.objective_target );
		level thread cleanup_temple();
		skipto::teleport_players( "dogleg_2", undefined );
	}
}

//this should clean up all ents/scripting/etc...when the players cleared the area
function cleanup_temple()
{
	if ( isdefined( level.temple_patroller_spawners ) )
	{
		foreach ( enemy in level.temple_patroller_spawners ) 
		{
			if ( isdefined( enemy ) )
			{
				enemy stealth_status::clean_icon();
				enemy Delete();
			}
		}
	}
	
	if ( isdefined( level.temple_hunters ) )
	{
		foreach ( enemy in level.temple_hunters ) 
		{
			if ( isdefined( enemy ) )
				enemy Delete();
		}
	}
	
	array::run_all( GetCorpseArray(), &Delete );
}

function setup_breakable_garden_windows()
{
	breakable_garden_windows = getentarray( "breakable_garden_window", "targetname" );
	array::thread_all( breakable_garden_windows, &breakable_garden_window_watcher );
}

function breakable_garden_window_watcher()
{
	self setcandamage( true );
	self.health = 10;
	
	while( 1 )
	{
		self waittill( "damage", damage, attacker );
	
		if( IsDefined( attacker ) && isplayer( attacker ) && isDefined( damage ) )
		{
			self.health -= damage;
	
			if( self.health <= 0 )
			{
				//play sound
				//play fx
				//connect pathing?  maybe if we want ai to use them to mantle through or something
				//self notsolid();
				//self Hide();
				self Delete();
				break;
			}
		}
	}
}
